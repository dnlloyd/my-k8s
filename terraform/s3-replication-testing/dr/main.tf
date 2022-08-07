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
          "${data.terraform_remote_state.primary.outputs.rep_test_bucket.arn}"
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
          "${data.terraform_remote_state.primary.outputs.rep_test_bucket.arn}/*"
        ]
      },
      {
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Effect": "Allow",
        "Resource": "${module.s3_rep_test_dr.rep_test_bucket.arn}/*"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "replication" {
#   role = aws_iam_role.s3_replication.name
#   policy_arn = aws_iam_policy.s3_replication.arn
# }

# resource "aws_s3_bucket_replication_configuration" "replication" {
#   # Must have bucket versioning enabled first
#   # depends_on = [aws_s3_bucket_versioning.source]

#   role = aws_iam_role.s3_replication.arn
#   bucket = data.terraform_remote_state.primary.outputs.rep_test_bucket.rep_test_bucket.id

#   rule {
#     status = "Enabled"

#     destination {
#       bucket = module.s3_rep_test_dr.rep_test_bucket_arn
#       storage_class = "STANDARD"
#     }
#   }
# }
