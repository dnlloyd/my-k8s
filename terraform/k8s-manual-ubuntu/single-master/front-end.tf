variable "k8s_api_domain_name" {
  default = "myk8s.fhcdan.net"
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

#############################################################
# ACM

resource "aws_acm_certificate" "k8s_api" {
  count = var.use_nlb ? 1 : 0

  domain_name = var.k8s_api_domain_name
  validation_method = "DNS"
  subject_alternative_names = [var.k8s_api_domain_name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  count = var.use_nlb ? 1 : 0

  allow_overwrite = true
  name = tolist(aws_acm_certificate.k8s_api[0].domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.k8s_api[0].domain_validation_options)[0].resource_record_value]
  ttl = 60
  type = tolist(aws_acm_certificate.k8s_api[0].domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  count = var.use_nlb ? 1 : 0

  certificate_arn = aws_acm_certificate.k8s_api[0].arn
  validation_record_fqdns = [aws_route53_record.acm_validation[0].fqdn]
}

####################################################
# Load balancer

resource "aws_lb" "k8s_api" {
  count = var.use_nlb ? 1 : 0

  name = "ubu-k8s-api"
  load_balancer_type = "network"
  subnets = var.subnets
}

resource "aws_lb_listener" "k8s_api" {
  count = var.use_nlb ? 1 : 0

  load_balancer_arn = aws_lb.k8s_api[0].arn
  port = "443"
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.k8s_api[0].arn
  }
}

resource "aws_lb_target_group" "k8s_api" {
  count = var.use_nlb ? 1 : 0

  name = "ubu-k8s-api"
  port = 6443
  protocol = "TCP"
  vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "k8s_api" {
  count = var.use_nlb ? 1 : 0

  target_group_arn = aws_lb_target_group.k8s_api[0].arn
  target_id = aws_instance.master.id
  port = 6443
}

resource "aws_route53_record" "k8s_api_lb" {
  count = var.use_nlb ? 1 : 0

  zone_id = data.aws_route53_zone.main.zone_id
  name = var.k8s_api_domain_name
  type = "A"

  alias {
    name = aws_lb.k8s_api[0].dns_name
    zone_id = aws_lb.k8s_api[0].zone_id
    evaluate_target_health = false
  }
}

#############################################################
# Elastic IP

resource "aws_route53_record" "k8s_ip" {
  count = var.use_nlb ? 0 : 1

  zone_id = data.aws_route53_zone.main.zone_id
  name = var.k8s_api_domain_name
  type = "A"
  ttl = 300
  records = [aws_eip.master[0].public_ip]
}

resource "aws_eip" "master" {
  count = var.use_nlb ? 0 : 1

  instance = aws_instance.master.id
  vpc      = true
}
