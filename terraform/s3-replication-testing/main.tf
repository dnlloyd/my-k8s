provider "aws" {
  region  = "us-east-1"
}

# provider "aws" {
#   alias   = "dr"
#   region  = "us-east-2"
# }

module "s3_rep_test" {
  source = "../modules/s3-replication-one-way"

  # providers = {
  #   aws = aws.dr
  # }

  name = "primary"
}

output "bucket_name" {
  value = s3_rep_test.bucket_name
}