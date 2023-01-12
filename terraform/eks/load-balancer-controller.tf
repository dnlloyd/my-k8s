# Guides
# 1. https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/
# 2. https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
# 3. https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html

# Todo: automate all of this
# Deployments
# 1. cert manager: kubectl apply -f cert-manager-v1_5_4.yaml
# 2. load balancer controller: kubectl apply -f lbc-v2_4_5-full.yaml
# 3. ingress class: kubectl apply -f ingclass-v2_4_5.yaml

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
