provider "aws" {
  region  = "us-east-2"
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

  name = "dr"
  dr_enabled = true
}

output "rep_test_bucket_name_dr" {
  value = module.s3_rep_test_dr.bucket_name
}

data "aws_s3_bucket" "rep_test_primary" {
  bucket = data.terraform_remote_state.primary.outputs.rep_test_bucket_name
}

data "aws_s3_bucket" "rep_test_dr" {
  bucket = module.s3_rep_test_dr.bucket_name
}

resource "aws_iam_role" "s3_replication" {
  name = "S3ReplicationTest"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "s3.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_policy" "s3_replication" {
  name = "S3ReplicationTest"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
          "${data.aws_s3_bucket.rep_test_primary.arn}"
        ]
      },
      {
        "Action": [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        "Effect": "Allow",
        "Resource": [
          "${data.aws_s3_bucket.rep_test_primary.arn}/*"
        ]
      },
      {
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Effect": "Allow",
        "Resource": "${data.aws_s3_bucket.rep_test_dr}/*"
      }
    ]
  })
}
