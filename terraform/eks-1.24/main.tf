locals {
  cluster_version = "1.24"
  cluster_name = "my-k8s"
  vpc_id = "vpc-065b33a8baa73e2a3"
  instance_type = "m5.2xlarge"
  ec2_key_pair_name = "fh-sandbox"
  disk_size = 90

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
    ingress_ssh = {
      description = "Node ssh ingress"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags_nodegroup = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

module "eks" {
  create = true

  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.3"

  cluster_name = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id = local.vpc_id
  subnet_ids = local.subnet_ids

  # cluster_addons = {
  #   aws-ebs-csi-driver = {
  #     service_account_role_arn = ""
  #   }
  # }

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

      ############### Launch template ###############
      # AMI comes from: https://github.com/awslabs/amazon-eks-ami
      # create_launch_template = false
      # launch_template_name = ""
      create_launch_template = true
      launch_template_name = "${local.cluster_name}-lc"

      key_name = local.ec2_key_pair_name

      ebs_optimized = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"

          ebs = {
            volume_size = local.disk_size # Todo: Which will win, this or disk_size
            volume_type = "gp3"
            encrypted   = true
          }
        }
      }

      # Incompatible with using a launch template
      # remote_access = {
      #   ec2_ssh_key = local.ec2_key_pair_name
      #   source_security_group_ids = ["sg-0d085d64e2390eacd"]
      # }

      subnet_ids = local.subnet_ids

      min_size = 3
      max_size = 6
      desired_size = 3

      instance_types = [local.instance_type]
      capacity_type = "ON_DEMAND"
      # disk_size = local.disk_size # Todo: this gets trumped by volume_size in LC

      # Specify volumes to attach to the instance besides the volumes specified by the AMI
      # block_device_mappings = local.node_block_device # Todo: This requires a custom launch template

      # ami_id = data.aws_ami.eks_default.image_id
      # enable_bootstrap_user_data = true
      # bootstrap_extra_args = "--container-runtime containerd --kubelet-extra-args '--max-pods=20'"

      # 1.23 or earlier
      # Enable containerd, ssm
      # Explicitly set container runtime on EKS with Kubernetes version 1.22:
      # Ref: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v18.26.1/examples/eks_managed_node_group#container-runtime--user-data
      # This section should be updated / removed when updating to Kubernetes 1.24
      # Ref: https://docs.aws.amazon.com/eks/latest/userguide/dockershim-deprecation.html
      # Setting max pod to 110
      # Ref: https://aws.amazon.com/blogs/containers/amazon-vpc-cni-increases-pods-per-node-limits/
      # pre_bootstrap_user_data = <<-EOT
      # #!/bin/bash
      # set -ex
      # cat <<-EOF > /etc/profile.d/bootstrap.sh
      # export CONTAINER_RUNTIME="containerd"
      # export USE_MAX_PODS=false
      # export KUBELET_EXTRA_ARGS="--max-pods=110"
      # EOF
      # # Source extra environment variables in bootstrap script
      # sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
      # EOT

      # 1.24 or later
      pre_bootstrap_user_data = <<-EOT
      export CONTAINER_RUNTIME="containerd"
      export USE_MAX_PODS=false
      EOT

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }

      create_iam_role = true
      iam_role_name = "${local.cluster_name}-eks-managed-node-group"
      iam_role_use_name_prefix = false
      iam_role_description = "${local.cluster_name} EKS managed node group role"
      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
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

      tags = merge(local.additional_tags, local.tags_nodegroup)
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

resource "kubernetes_namespace" "prometheus" {
  depends_on = [module.eks]

  metadata {
    name = "prometheus"
  }
}
