resource "helm_release" "web_4j" {
  name  = "web-j4"
  chart = "../../apps/helm/web-j4_docker-hub"
  namespace = "www"
}
