data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.cluster_version}-v*"]
  }
}

locals {
  self_managed_secondary = {
    name            = "${local.cluster_name}-self-secondary"
    use_name_prefix = false

    subnet_ids = local.subnet_ids

    min_size     = 1
    max_size     = 4
    desired_size = 2

    ami_id               = data.aws_ami.eks_default.id
    bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110' '--node-labels=node-restriction.kubernetes.io/nodegroup=secondary'"

    pre_bootstrap_user_data = <<-EOT
    export CONTAINER_RUNTIME="containerd"
    export USE_MAX_PODS=false
    EOT

    post_bootstrap_user_data = <<-EOT
    echo "you are free little kubelet!"
    EOT

    instance_type = local.instance_type

    launch_template_name            = "${local.cluster_name}-self-secondary"
    launch_template_use_name_prefix = true
    launch_template_description     = "Self managed secondary node group launch template"

    ebs_optimized          = true
    # vpc_security_group_ids = [aws_security_group.additional.id]
    enable_monitoring      = true

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = local.disk_size
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }

    # metadata_options = {
    #   http_endpoint               = "enabled"
    #   http_tokens                 = "required"
    #   http_put_response_hop_limit = 2
    #   instance_metadata_tags      = "disabled"
    # }

    # capacity_reservation_specification = {
    #   capacity_reservation_target = {
    #     capacity_reservation_id = aws_ec2_capacity_reservation.targeted.id
    #   }
    # }

    create_iam_role = true
    iam_role_name = "${local.cluster_name}-eks-self-managed-node-group"
    iam_role_use_name_prefix = false
    iam_role_description = "${local.cluster_name} EKS self managed node group role"
    iam_role_tags = local.additional_tags
    iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

    create_security_group = true
    security_group_name = "${local.cluster_name}-eks-managed-node-group"
    security_group_use_name_prefix = true
    security_group_description = "${local.cluster_name} EKS self managed node group security group"
    security_group_rules = local.node_sg_rules
    security_group_tags = local.additional_tags

    tags = local.additional_tags
  }
}
