# Apply #1
resource "aws_s3_bucket" "rep_test" {
  # bucket = var.dr_enabled ? "reptest-dr" : "reptest"
  bucket_prefix = "reptest"
}

resource "aws_s3_bucket_acl" "rep_test_bucket_acl" {
  bucket = aws_s3_bucket.rep_test.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "rep_test" {
  bucket = aws_s3_bucket.rep_test.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "rep_test_bucket" {
  value = aws_s3_bucket.rep_test
}
