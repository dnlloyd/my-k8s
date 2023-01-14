resource "kubernetes_namespace" "cert_manager" {
  depends_on = [module.eks]

  metadata {
    name = "cert-manager"
  }
}

data "kubectl_file_documents" "cert_manager_pre" {
  content = file("${path.module}/../../deploy/cluster-services/cert-manager/tf1-pre-deployments-cert-manager.yaml")
}

resource "kubectl_manifest" "cert_manager_pre" {
  depends_on = [module.load_balancer_controller_irsa]

  for_each  = data.kubectl_file_documents.cert_manager_pre.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "cert_manager_deployments" {
  content = file("${path.module}/../../deploy/cluster-services/cert-manager/tf2-deployments-cert-manager.yaml")
}

resource "kubectl_manifest" "cert_manager_deployments" {
  depends_on = [kubectl_manifest.cert_manager_pre]

  for_each  = data.kubectl_file_documents.cert_manager_deployments.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "cert_manager_post" {
  content = file("${path.module}/../../deploy/cluster-services/cert-manager/tf3-post-deployments-cert-manager.yaml")
}

resource "kubectl_manifest" "cert_manager_post" {
  depends_on = [kubectl_manifest.cert_manager_deployments]

  for_each  = data.kubectl_file_documents.cert_manager_post.manifests
  yaml_body = each.value
}
