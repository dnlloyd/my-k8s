resource "aws_ecr_repository" "dnlloyd" {
  name = "dnlloyd"
  image_tag_mutability = "MUTABLE"
}
