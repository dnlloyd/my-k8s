terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16"
    }
    # argocd = {
    #   source = "oboukili/argocd"
    #   version = "0.4.7"
    # }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  } 
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.eks.token
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = false
}

# provider "argocd" {
#   server_addr = "argocd.local:443" # env ARGOCD_SERVER
#   auth_token  = "1234..." # env ARGOCD_AUTH_TOKEN
#   # username  = "admin" # env ARGOCD_AUTH_USERNAME
#   # password  = "foo" # env ARGOCD_AUTH_PASSWORD
#   insecure    = false # env ARGOCD_INSECURE
# }

# provider "helm" {
#   kubernetes {
#     host = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     token = data.aws_eks_cluster_auth.eks.token
#   }
# }
