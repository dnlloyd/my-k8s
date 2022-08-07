variable "primary_remote_state" {
  default = null
}

# provider "aws" {
#   alias = "primary"
# }

# data "aws_s3_bucket" "rep_test_primary" {
#   count = var.dr_enabled ? 1 : 0
#   provider = aws.primary

#   bucket = 
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
