provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  alias   = "dr"
  region  = "us-east-2"
}

module "s3_rep_test" {
  source = "../modules/s3-replication-one-way"

  # providers = {
  #   aws = aws.dr
  # }

  name = "primary"
}

module "s3_rep_test_dr" {
  source = "../modules/s3-replication-one-way"

  providers = {
    aws = aws.dr
  }

  name = "dr"
  dr_enabled = true
}

