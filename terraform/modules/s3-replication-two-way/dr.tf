# This file contains variables, resources, etc. used only when DR context is applied

provider "aws" {
  alias = "primary"
  region  = "us-east-1"
}

# By default, DR is not enabled
variable "dr_enabled" {
  default = false
}

# In the DR context, this variable contains a map of all the primary deployment's outputs
variable "primary_remote_state" {
  default = null
  type = map(any)
}

# Only create role in DR context
resource "aws_iam_role" "s3_replication" {
  count = var.dr_enabled ? 1 : 0

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

# Only create policy in DR context
resource "aws_iam_policy" "s3_replication" {
  count = var.dr_enabled ? 1 : 0

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
          "${var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn}",
          "${aws_s3_bucket.rep_test.arn}"
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
          "${var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn}/*",
          "${aws_s3_bucket.rep_test.arn}/*"
        ]
      },
      {
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_s3_bucket.rep_test.arn}/*",
          "${var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Only create attachment in DR context
resource "aws_iam_role_policy_attachment" "replication" {
  count = var.dr_enabled ? 1 : 0

  role = aws_iam_role.s3_replication[0].name
  policy_arn = aws_iam_policy.s3_replication[0].arn
}

# In a DR context, the aws_s3_bucket_replication_configuration resource below uses the 
# primary region provider. This allows us to get the DR region bucket resource for the 
# destination
locals {
  rep_test_bucket_arn = aws_s3_bucket.rep_test.arn
}

# Replication from primary region to DR region
resource "aws_s3_bucket_replication_configuration" "replication_primary_to_dr" {
  count = var.dr_enabled ? 1 : 0
  provider = aws.primary
  
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.rep_test]

  role = aws_iam_role.s3_replication[0].arn
  bucket = var.primary_remote_state.rep_test_outputs.rep_test_bucket.id

  rule {
    status = "Enabled"

    destination {
      bucket = local.rep_test_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

# Replication from DR region to primary region
resource "aws_s3_bucket_replication_configuration" "replication_dr_to_primary" {
  count = var.dr_enabled ? 1 : 0
  # provider = aws.primary
  
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.rep_test]

  role = aws_iam_role.s3_replication[0].arn
  bucket = aws_s3_bucket.rep_test.id

  rule {
    status = "Enabled"

    destination {
      bucket = var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn
      storage_class = "STANDARD"
    }
  }
}
