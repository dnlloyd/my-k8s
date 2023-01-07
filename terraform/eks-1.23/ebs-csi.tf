# https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
# Kubernetes 1.23 and higher

module "irsa_ebs_csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.8.0"

  role_name = "${local.cluster_name}-IrsaEbsCsi2"
  role_description = "IRSA for EBS CSI"

  attach_ebs_csi_policy = true

  # assume_role_condition_test = "StringLike"
  policy_name_prefix = "${local.cluster_name}-IrsaEbsCsi"

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "kubernetes_service_account" "ebs_csi" {
  metadata {
    name = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa_ebs_csi.iam_role_arn
    }
  }
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name      = local.cluster_name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = "v1.13.0-eksbuild.2"
  service_account_role_arn = module.irsa_ebs_csi.iam_role_arn
}
