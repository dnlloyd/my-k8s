variable "primary_remote_state" {
  default = null
  type = map(any)
}

provider "aws" {
  alias = "primary"
  region  = "us-east-1"
}

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
          "${var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn}"
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
          "${var.primary_remote_state.rep_test_outputs.rep_test_bucket.arn}/*"
        ]
      },
      {
        "Action": [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.rep_test.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  count = var.dr_enabled ? 1 : 0

  role = aws_iam_role.s3_replication[0].name
  policy_arn = aws_iam_policy.s3_replication[0].arn
}

locals {
  rep_test_bucket_arn = aws_s3_bucket.rep_test.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
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
