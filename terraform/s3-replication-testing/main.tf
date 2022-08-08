provider "aws" {
  region  = "us-east-1"
}

module "s3_rep_test" {
  source = "../modules/s3-replication-one-way"
}

# Net new
output "rep_test_bucket" {
  value = module.s3_rep_test
}
