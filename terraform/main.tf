locals {
  cluster_version = "1.22"
  cluster_name = "my-eks-${replace(local.cluster_version, ".", "_")}"
  vpc_id = "vpc-065b33a8baa73e2a3"
  instance_type = "t3.micro"
  ec2_key_pair_name = "fh-sandbox"
  disk_size = 20

  subnet_ids = [
    "subnet-08090a8df7f3a8c63",
    "subnet-07f0c07531ff40032",
    "subnet-0377599577dac9845"
  ]

  additional_tags = {
    CommunityModuleVersion = "18.26.3"
    K8sVersion = local.cluster_version
  }

  node_sg_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Node all egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_cluster_to_nodes = {
      description                   = "Cluster to Node communication"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.3"

  cluster_name = local.cluster_name
  
  cluster_version = local.cluster_version

  vpc_id = local.vpc_id
  subnet_ids = local.subnet_ids

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days  = 1

  cluster_security_group_additional_rules = {
    cluster_ingress_public = {
      description = "K8s Cluster API Public Access"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources = ["secrets"]
    }
  ]

  tags = local.additional_tags
  
  ############################################
  # aws-auth configmap
  ############################################
  
  # create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn = "arn:aws:iam::458891109543:role/EksAdmin"
      username = "eks-manager-role"
      groups = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn = "arn:aws:iam::458891109543:user/dnlloyd"
      username = "dnlloyd"
      groups = ["system:masters"]
    },
  ]

  ############################################
  # Managed node group(s)
  ############################################

  eks_managed_node_groups = {
    default_node_group = {
      name = "${local.cluster_name}-managed"
      create_launch_template = false
      launch_template_name = ""

      subnet_ids = local.subnet_ids

      min_size = 2
      max_size = 4
      desired_size = 2

      instance_types = [local.instance_type]
      capacity_type = "SPOT"
      disk_size = local.disk_size

      # TODO: Enable EBS volume encryption by using custom launch template

      remote_access = {
        ec2_ssh_key = local.ec2_key_pair_name
        source_security_group_ids = ["sg-0d085d64e2390eacd"]
      }

      # Specify volumes to attach to the instance besides the volumes specified by the AMI
      # block_device_mappings = local.node_block_device # Todo: This requires a custom launch template

      # ami_id = data.aws_ami.eks_default.image_id
      # enable_bootstrap_user_data = true
      # bootstrap_extra_args = "--container-runtime containerd --kubelet-extra-args '--max-pods=20'"

      # Enable containerd, ssm
      pre_bootstrap_user_data = <<-EOT
      export CONTAINER_RUNTIME="containerd"
      EOT

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }

      create_iam_role = true
      iam_role_name = "${local.cluster_name}-eks-managed-node-group"
      iam_role_use_name_prefix = false
      iam_role_description = "${local.cluster_name} EKS managed node group role"
      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

      # TODO: Enforce compliance tags at the module level
      iam_role_tags = local.additional_tags
      
      create_security_group = true
      security_group_name = "${local.cluster_name}-eks-managed-node-group"
      security_group_use_name_prefix = false
      security_group_description = "${local.cluster_name} EKS managed node group security group"
      security_group_rules = local.node_sg_rules

      # TODO: Enforce compliance tags at the module level
      security_group_tags = local.additional_tags

      # A list of security group IDs to associate
      # vpc_security_group_ids  = [aws_security_group.additional.id]

      # TODO: Enforce compliance tags at the module level
      tags = local.additional_tags
    }
  }
}

# KMS key for secret envelope encryption
resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key for ${local.cluster_name}"
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = {
    Name = "${local.cluster_name}-key"
    Note = "Created by terraform for EKS cluster ${local.cluster_name}"
  }
}

resource "aws_ecr_repository" "dnlloyd" {
  name = "dnlloyd"
  image_tag_mutability = "MUTABLE"
}
