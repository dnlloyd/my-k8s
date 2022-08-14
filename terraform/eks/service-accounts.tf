############# External DNS
module "irsa_external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.0"

  role_name = "${local.cluster_name}-IrsaExternalDns"
  role_description = "Irsa for External Dns"
  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z03314733U0PEMT10QF2N"]

  assume_role_condition_test = "StringLike"
  policy_name_prefix = "IrsaExternalDns"

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["www:external-dns"]
    }
  }
}

resource "kubernetes_namespace" "www" {
  metadata {
    name = "www"
  }
}

resource "kubernetes_service_account" "service_accounts" {
  depends_on = [kubernetes_namespace.www]

  automount_service_account_token = true

  metadata {
    name = "external-dns"
    namespace = "www"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa_external_dns.iam_role_arn
    }
  }
}
