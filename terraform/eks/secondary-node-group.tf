# resource "aws_eks_node_group" "secondary" {
#   cluster_name    = module.eks.cluster_id
#   node_group_name = "secondary"
#   node_role_arn   = "arn:aws:iam::458891109543:role/my-eks-1-22-eks-managed-node-group"
#   subnet_ids      = local.subnet_ids

#   instance_types = ["t3.micro"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 0
#   }

#   update_config {
#     max_unavailable = 2
#   }

#   tags = {
#     NodeGroupTagTest = "True"
#   }
# }
