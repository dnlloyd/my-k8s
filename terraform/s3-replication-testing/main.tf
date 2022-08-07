provider "aws" {
  region  = "us-east-1"
}

module "s3_rep_test" {
  source = "../modules/s3-replication-one-way"

  name = "primary"
}

output "rep_test_bucket_name" {
  value = module.s3_rep_test.bucket_name
}
