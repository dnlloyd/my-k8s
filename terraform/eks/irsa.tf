# module "irsa_ebs_csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.0"

#   role_name = "${local.cluster_name}-IrsaEbsCsi"
#   role_description = "IRSA for EBS CSI"

#   attach_ebs_csi_policy = true

#   # assume_role_condition_test = "StringLike"
#   policy_name_prefix = "${local.cluster_name}-IrsaEbsCsi"

#   oidc_providers = {
#     main = {
#       provider_arn = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#     }
#   }
# }


# module "cluster_autoscaler_irsa" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "4.13.1"

#   role_name = "${local.cluster_name}-IrsaClusterAutoscaler"
#   role_description = "IRSA role for cluster autoscaler"

#   attach_cluster_autoscaler_policy = true
#   cluster_autoscaler_cluster_ids = [module.eks.cluster_id]

#   oidc_providers = {
#     main = {
#       provider_arn = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:cluster-autoscaler"]
#     }
#   }
# }
