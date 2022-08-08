resource "aws_s3_bucket" "rep_test" {
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

# Net new: Capture output of resources that will need to be looked up in DR context
output "rep_test_bucket" {
  value = aws_s3_bucket.rep_test
}
