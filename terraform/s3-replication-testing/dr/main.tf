provider "aws" {
  alias = "dr"
  region  = "us-east-2"
}

provider "aws" {
  alias = "primary"
  region  = "us-east-1"
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
    aws = aws.dr
    aws.shared = aws.primary
  }

  dr_enabled = true
  primary_remote_state = data.terraform_remote_state.primary.outputs
}
