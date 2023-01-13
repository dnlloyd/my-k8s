data "kubectl_file_documents" "cert_manager" {
  content = file("${path.module}/../../deploy/cluster-services/cert-manager/cert-manager-v1_5_4.yaml")
}

resource "kubectl_manifest" "cert_manager" {
  depends_on = [module.load_balancer_controller_irsa]

  for_each  = data.kubectl_file_documents.cert_manager.manifests
  yaml_body = each.value
}
