terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.16"
    # }
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
  host                   = module.tools_test_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.tools_test_eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.tools_test_eks.cluster_name]
  }
}

provider "kubectl" {
  host                   = module.my_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.my_eks.cluster_certificate_authority_data)
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
#     host = module.my_eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.my_eks.cluster_certificate_authority_data)
#     token = data.aws_eks_cluster_auth.eks.token
#   }
# }
