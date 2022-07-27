# resource "aws_eks_node_group" "secondary" {
#   cluster_name    = module.eks.cluster_id
#   node_group_name = "secondary"
#   node_role_arn   = "arn:aws:iam::458891109543:role/my-eks-1-22-eks-managed-node-group"
#   subnet_ids      = local.subnet_ids

#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 2
#   }

#   tags = {
#     NodeGroupTagTest = "True"
#   }
# }

# resource "aws_autoscaling_group_tag" "eks_node_groups_asgs" {
#   for_each = toset(
#     [for asg in flatten(
#       [for resources in aws_eks_node_group.secondary.resources : resources.autoscaling_groups]
#     ) : asg.name]
#   )

#   autoscaling_group_name = each.value

#   tag {
#     key   = "AsgTagTestHardCoded"
#     value = "true"

#     propagate_at_launch = false
#   }
# }
