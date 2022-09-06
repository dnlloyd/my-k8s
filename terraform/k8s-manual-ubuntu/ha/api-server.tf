variable "k8s_api_domain_name" {
  default = "myk8sapi.fhcdan.net"
}

variable "hosted_zone_name" {
  default = "fhcdan.net"
}

variable "vpc_id" {
  default = "vpc-065b33a8baa73e2a3"
}

variable "subnets" {
  default = [
    "subnet-0799f4a5fa38ae5f7",
    "subnet-07f0c07531ff40032",
    "subnet-00e8e661d1aa7a9db",
    "subnet-0377599577dac9845",
    "subnet-08090a8df7f3a8c63",
    "subnet-0e0a967b1d1553dcd"
  ]
}

data "aws_route53_zone" "main" {
  name = var.hosted_zone_name
}

##### ACM ##############################################
resource "aws_acm_certificate" "k8s_api" {
  domain_name = var.k8s_api_domain_name
  validation_method = "DNS"
  subject_alternative_names = [var.k8s_api_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  allow_overwrite = true
  name = tolist(aws_acm_certificate.k8s_api.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.k8s_api.domain_validation_options)[0].resource_record_value]
  ttl = 60
  type = tolist(aws_acm_certificate.k8s_api.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.k8s_api.arn
  validation_record_fqdns = [aws_route53_record.acm_validation.fqdn]
}

####################################################
# Load balancer

resource "aws_lb" "k8s_api" {
  name = "ubu-k8s-api-server"
  load_balancer_type = "network"
  subnets = var.subnets
}

resource "aws_lb_listener" "k8s_api" {
  load_balancer_arn = aws_lb.k8s_api.arn
  port = "443"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.k8s_api.arn
  }
}

resource "aws_lb_target_group" "k8s_api" {
  name = "ubu-k8s-api-servers"
  port = 6443
  protocol = "TCP"
  vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "k8s_api" {
  count = var.control_plane_size

  target_group_arn = aws_lb_target_group.k8s_api.arn
  target_id = aws_instance.master[count.index].id
  port = 6443
}

resource "aws_route53_record" "k8s_api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = var.k8s_api_domain_name
  type = "A"

  alias {
    name = aws_lb.k8s_api.dns_name
    zone_id = aws_lb.k8s_api.zone_id
    evaluate_target_health = false
  }
}
