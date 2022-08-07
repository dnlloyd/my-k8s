# Apply #1
resource "aws_s3_bucket" "rep_test" {
  # bucket = var.dr_enabled ? "reptest-dr" : "reptest"
  bucket_prefix = "reptest"
}

output "bucket_name" {
  value = aws_s3_bucket.rep_test.arn
}

# resource "aws_iam_role_policy_attachment" "replication" {
#   role = aws_iam_role.s3_replication.name
#   policy_arn = aws_iam_policy.s3_replication.arn
# }

# resource "aws_s3_bucket_acl" "source_bucket_acl" {
#   bucket = aws_s3_bucket.rep_test.id
#   acl = "private"
# }

# resource "aws_s3_bucket_versioning" "source" {
#   bucket = aws_s3_bucket.rep_test.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_replication_configuration" "replication" {
#   # Must have bucket versioning enabled first
#   depends_on = [aws_s3_bucket_versioning.source]

#   role = aws_iam_role.s3_replication.arn
#   bucket = aws_s3_bucket.rep_test.id

#   rule {
#     status = "Enabled"

#     destination {
#       bucket = aws_s3_bucket.destination.arn
#       storage_class = "STANDARD"
#     }
#   }
# }
