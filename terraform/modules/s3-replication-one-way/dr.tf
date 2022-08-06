# data "tfe_outputs" "foo" {
#   count = var.dr_enabled ? 1 : 0

#   organization = "fhc-dan"
#   workspace = "s3-replication-testing"
# }

# provider "aws" {
#   alias = "primary"
# }

# data "aws_s3_bucket" "rep_test_primary" {
#   count = var.dr_enabled ? 1 : 0
#   provider = aws.primary

#   bucket = 
# }

# resource "aws_iam_role" "s3_replication" {
#   count = var.dr_enabled ? 1 : 0

#   name = "S3ReplicationTest"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "s3.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "s3_replication" {
#   count = var.dr_enabled ? 1 : 0

#   name = "S3ReplicationTest"

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": [
#           "s3:GetReplicationConfiguration",
#           "s3:ListBucket"
#         ],
#         "Effect": "Allow",
#         "Resource": [
#           "${aws_s3_bucket.rep_test.arn}"
#         ]
#       },
#       {
#         "Action": [
#           "s3:GetObjectVersionForReplication",
#           "s3:GetObjectVersionAcl",
#           "s3:GetObjectVersionTagging"
#         ],
#         "Effect": "Allow",
#         "Resource": [
#           "${aws_s3_bucket.rep_test.arn}/*"
#         ]
#       },
#       {
#         "Action": [
#           "s3:ReplicateObject",
#           "s3:ReplicateDelete",
#           "s3:ReplicateTags"
#         ],
#         "Effect": "Allow",
#         "Resource": "${aws_s3_bucket.rep_test.arn}/*"
#       }
#     ]
#   })
# }

# resource "aws_s3_bucket" "destination" {
#   provider = aws.dr
  
#   bucket = "destination-reptest-fhcdan-net"
# }

# resource "aws_s3_bucket_versioning" "destination" {
#   provider = aws.dr

#   bucket = aws_s3_bucket.destination.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
