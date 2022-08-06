provider "aws" {
  region  = "us-east-2"
}

# provider "aws" {
#   alias   = "primary"
#   region  = "us-east-1"
# }

module "s3_rep_test_dr" {
  source = "../../modules/s3-replication-one-way"

  # providers = {
  #   aws = aws.primary
  # }

  name = "dr"
  dr_enabled = true
}

data "tfe_outputs" "fhc_dan" {
  # count = var.dr_enabled ? 1 : 0
  
  organization = "fhc-dan"
  workspace = "s3-replication-testing"
}

output "primary_bucket_name" {
  value = data.tfe_outputs.fhc_dan.values
  sensitive = true
}
