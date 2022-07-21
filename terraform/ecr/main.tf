resource "aws_ecr_repository" "web_j4" {
  name = "web-j4"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "web_kz" {
  name = "web-kz"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "web_skp" {
  name = "web-skp"
  image_tag_mutability = "MUTABLE"
}
