resource "aws_ec2_tag" "k8s_subnet_tags_for_lbc_1" {
  for_each    = toset(local.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "k8s_subnet_tags_for_lbc_2" {
  for_each    = toset(local.subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = 1
} 

module "load_balancer_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "${module.eks.cluster_name}-LoadBalancer-IRSA"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "load_balancer_controller" {
  automount_service_account_token = true

  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa.iam_role_arn
    }
  }
}

data "kubectl_file_documents" "load_balancer_controller" {
  content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/lbc-v2_4_5-full.yaml")
}

resource "kubectl_manifest" "load_balancer_controller" {
  depends_on = [kubectl_manifest.cert_manager]
  
  for_each  = data.kubectl_file_documents.load_balancer_controller.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "ingclass" {
  content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/ingclass-v2_4_5.yaml")
}

resource "kubectl_manifest" "ingclass" {
  depends_on = [kubectl_manifest.load_balancer_controller]

  for_each  = data.kubectl_file_documents.ingclass.manifests
  yaml_body = each.value
}
