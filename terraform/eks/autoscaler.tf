# module "cluster_autoscaler_irsa" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.0"

#   role_name = "${module.my_eks.cluster_name}-IrsaAutoscaler"
#   role_description = "IRSA role for cluster autoscaler"
#   attach_cluster_autoscaler_policy = true
#   cluster_autoscaler_cluster_ids = [module.my_eks.cluster_name]

#   oidc_providers = {
#     main = {
#       provider_arn = module.my_eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:cluster-autoscaler"]
#     }
#   }
# }
