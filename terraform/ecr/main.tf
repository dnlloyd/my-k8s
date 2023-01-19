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

resource "aws_ecr_repository" "web_fam_meme" {
  name = "web-fam-meme"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "flask_auth" {
  name = "flask-auth"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "aspnet-core" {
  name = "aspnet-core"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "foo" {
  name = "foo"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "bar" {
  name = "bar"
  image_tag_mutability = "MUTABLE"
}
