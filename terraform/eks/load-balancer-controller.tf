# Not needed: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# resource "aws_ec2_tag" "k8s_subnet_tags_for_lbc_1" {
#   for_each    = toset(local.subnet_ids)
#   resource_id = each.value
#   key         = "kubernetes.io/cluster/${local.cluster_name}"
#   value       = "owned"
# }

# https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
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

# Todo: reconcile with deploy/cluster-services/aws-load-balancer-controller/lbc-full-orig/v2_4_6_full.yaml
resource "kubernetes_service_account" "load_balancer_controller" {
  automount_service_account_token = true

  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    
    annotations = {
      "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa.iam_role_arn
    }

    labels = { 
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }
}

# all-in-one deploy
# data "kubectl_file_documents" "load_balancer_controller_all" {
#   content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/lbc-full-orig/v2_4_6_full.yaml")
# }

# resource "kubectl_manifest" "load_balancer_controller_all" {
#   depends_on = [kubectl_manifest.cert_manager_post]
  
#   for_each  = data.kubectl_file_documents.load_balancer_controller_all.manifests
#   yaml_body = each.value
# }

# incremental deploy (Todo: currently non-functional)
# data "kubectl_file_documents" "load_balancer_controller_pre" {
#   content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/tf1-pre-deployments-lbc.yaml")
# }

# resource "kubectl_manifest" "load_balancer_controller_pre" {
#   depends_on = [kubectl_manifest.cert_manager_post]
  
#   for_each  = data.kubectl_file_documents.load_balancer_controller_pre.manifests
#   yaml_body = each.value
# }

# data "kubectl_file_documents" "load_balancer_controller_deployment" {
#   content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/tf2-deployments-lbc.yaml")
# }

# resource "kubectl_manifest" "load_balancer_controller_deployment" {
#   depends_on = [kubectl_manifest.load_balancer_controller_pre]
  
#   for_each  = data.kubectl_file_documents.load_balancer_controller_deployment.manifests
#   yaml_body = each.value

#   timeouts {
#     create = "3m"
#     update = "3m"
#   }
# }

# data "kubectl_file_documents" "load_balancer_controller_post" {
#   content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/tf3-post-deployments-lbc.yaml")
# }

# resource "kubectl_manifest" "load_balancer_controller_post" {
#   depends_on = [kubectl_manifest.load_balancer_controller_deployment]
  
#   for_each  = data.kubectl_file_documents.load_balancer_controller_post.manifests
#   yaml_body = each.value
# }

# ingress class
# data "kubectl_file_documents" "ingclass" {
#   content = file("${path.module}/../../deploy/cluster-services/aws-load-balancer-controller/v2_4_6_ingress_class.yaml")
# }

# resource "kubectl_manifest" "ingclass" {
#   depends_on = [kubectl_manifest.load_balancer_controller_all] # all in one
#   # depends_on = [kubectl_manifest.load_balancer_controller_post] # incremental

#   for_each  = data.kubectl_file_documents.ingclass.manifests
#   yaml_body = each.value
# }
