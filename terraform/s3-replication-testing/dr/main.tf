provider "aws" {
  alias = "dr"
  region  = "us-east-2"
  source  = "hashicorp/aws"
}

provider "aws" {
  alias = "primary"
  region  = "us-east-1"
  source  = "hashicorp/aws"
}

data "terraform_remote_state" "primary" {
  backend = "remote"

  config = {
    organization = "fhc-dan"
    workspaces = {
      name = "s3-replication-testing"
    }
  }
}

module "s3_rep_test_dr" {
  source = "../../modules/s3-replication-one-way"

  providers = {
    aws        = aws.dr
    aws.shared = aws.primary
  }

  dr_enabled = true
  primary_remote_state = data.terraform_remote_state.primary.outputs
}


# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 2.7.0"
#       configuration_aliases = [ aws.dr, aws.shared ]
#     }
#   }
# }