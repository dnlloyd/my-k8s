locals {
  cluster_version = "1.24"
  cluster_name = "my-k8s"
  vpc_id = "vpc-065b33a8baa73e2a3"
  instance_type = "m5.2xlarge"
  ec2_key_pair_name = "fh-sandbox"
  disk_size = 40

  subnet_ids = [
    "subnet-08090a8df7f3a8c63",
    "subnet-07f0c07531ff40032",
    "subnet-0377599577dac9845"
  ]

  additional_tags = {
    CommunityModuleVersion = "19.5.1"
    K8sVersion = local.cluster_version
  }

  tags_nodegroup = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

module "eks" {
  create = true

  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name = local.cluster_name
  cluster_version = local.cluster_version
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  vpc_id = local.vpc_id
  subnet_ids = local.subnet_ids

  # create_cni_ipv6_iam_policy = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

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

  create_kms_key = false
  cluster_encryption_config = {
    resources = ["secrets"]
    provider_key_arn = aws_kms_key.eks.arn
  }

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

      min_size = 1
      max_size = 6
      desired_size = 3

      instance_types = [local.instance_type]
      capacity_type = "ON_DEMAND"
      # disk_size = local.disk_size # Todo: this gets trumped by volume_size in LC

      # Specify volumes to attach to the instance besides the volumes specified by the AMI
      # block_device_mappings = local.node_block_device # Todo: This requires a custom launch template

      # These fields are for when using a custom ID
      # ami_id = data.aws_ami.eks_default.image_id
      # enable_bootstrap_user_data = true

      # bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110' '--node-labels=node-restriction.kubernetes.io/nodegroup=managed'"
      bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110'"

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
        max_unavailable_percentage = 75 # or set `max_unavailable`
      }

      create_iam_role = true
      iam_role_name = "${local.cluster_name}-eks-managed-node-group"
      iam_role_use_name_prefix = false
      iam_role_description = "${local.cluster_name} EKS managed node group role"
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
      iam_role_tags = local.additional_tags
      
      # No longer available in this module version
      # create_security_group = true
      # security_group_name = "${local.cluster_name}-eks-managed-node-group-ABOUT5"
      # security_group_use_name_prefix = false
      # security_group_description = "${local.cluster_name} EKS managed node group security group"
      # security_group_rules = local.node_sg_rules
      # security_group_tags = local.additional_tags

      # A list of security group IDs to associate
      vpc_security_group_ids  = [aws_security_group.additional_node.id]

      tags = merge(local.additional_tags, local.tags_nodegroup)
    }
  }

  # self_managed_node_groups = {
  #   self_managed_secondary = local.self_managed_secondary
  # }
}

resource "aws_security_group" "additional_node" {
  name = "${local.cluster_name}-ssh-and-friends"
  description = "Allow SSH to EKS nodes"
  vpc_id = local.vpc_id

  ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # For testing, allow all traffic between nodes (ephemeral ports are added by module)
  ingress {
    description = "All node to node"
    from_port = 0
    to_port = 1024
    protocol = "tcp"
    self = true
  }

  # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/
  # Todo: See if this gets automatically added by managed node group module
  # Not needed, gets applied automatically by EKS module
  # ingress {
  #   description = "LBC"
  #   from_port = 9443
  #   to_port = 9443
  #   protocol = "tcp"
  #   security_groups = [module.eks.cluster_primary_security_group_id]
  # }

  # https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
  # Not needed, gets applied automatically by EKS module
  # tags = {
  #   "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  # }
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

resource "kubernetes_namespace" "dev" {
  depends_on = [module.eks]

  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "prod" {
  depends_on = [module.eks]

  metadata {
    name = "prod"
  }
}

resource "kubernetes_namespace" "foo" {
  depends_on = [module.eks]

  metadata {
    name = "foo"
  }
}

resource "kubernetes_namespace" "bar" {
  depends_on = [module.eks]

  metadata {
    name = "bar"
  }
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [module.eks]

  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "vault" {
  depends_on = [module.eks]

  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace" "external-secrets" {
  depends_on = [module.eks]

  metadata {
    name = "external-secrets"
  }
}

resource "kubernetes_namespace" "ingress-shared" {
  depends_on = [module.eks]

  metadata {
    name = "ingress-shared"
  }
}

resource "kubernetes_namespace" "shared" {
  depends_on = [module.eks]

  metadata {
    name = "shared"
  }
}

# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "${module.eks.cluster_name}-VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}
