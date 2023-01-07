variable "external_dns_sa_name" {
  default = "external-dns"
}

variable "web_namespace" {
  default = "kube-system"
}

variable "domain_name" {
  default = "fhcdan.net"
}

data "aws_route53_zone" "web" {
  name = var.domain_name
}

module "irsa_external_dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.0"

  role_name = "${local.cluster_name}-IrsaExternalDns"
  role_description = "IRSA for External DNS"
  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = [data.aws_route53_zone.web.arn]

  assume_role_condition_test = "StringLike"
  policy_name_prefix = "${local.cluster_name}-IrsaExternalDns"

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${var.external_dns_sa_name}"]
    }
  }
}

resource "kubernetes_service_account" "external_dns" {
  # depends_on = [kubernetes_namespace.web]

  automount_service_account_token = true

  metadata {
    name = var.external_dns_sa_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa_external_dns.iam_role_arn
    }
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  depends_on = [module.eks]
  
  metadata {
    name = var.external_dns_sa_name
    labels = {
      "app.kubernetes.io/name" = var.external_dns_sa_name
    }
  }

  rule {
    api_groups = [""]
    resources = ["services","endpoints","pods","nodes"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = ["extensions","networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get","watch","list"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["list","watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns-viewer"
    labels = {
      "app.kubernetes.io/name" = var.external_dns_sa_name
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.external_dns.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.external_dns.metadata.0.name
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = "external-dns"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = var.external_dns_sa_name
    }
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        "app.kubernetes.io/name" = var.external_dns_sa_name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = var.external_dns_sa_name
        }
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata.0.name

        container {
          image = "k8s.gcr.io/external-dns/external-dns:v0.11.0"
          name = "external-dns"

          args = [
            "--source=service",
            "--source=ingress",
            "--domain-filter=${var.domain_name}",
            "--provider=aws",
            "--aws-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=${var.external_dns_sa_name}"
          ]
        }
      }
    }
  }
}
