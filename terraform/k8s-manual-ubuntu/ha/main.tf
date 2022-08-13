variable "worker_count" {
  default = 1
}

variable "control_plane_size" {
  default = 3
}

variable "vpc_cidr" {
  default = ["172.31.0.0/16"]  
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20220610"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "master" {
  count = var.control_plane_size

  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.medium" # Do not use smaller than a t3.medium (Coredns won't start)
  associate_public_ip_address = true
  key_name = "fh-sandbox"

  vpc_security_group_ids = [
    "sg-0d085d64e2390eacd",
    aws_security_group.k8s_ubu_master.id
  ]

  tags = {
    Name = "ubu-k8s-master-0${count.index + 1}"
  }
}

resource "aws_instance" "workers" {
  count = var.worker_count

  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.medium" # This allows for enough ENIs to run Argo and some other stuff
  associate_public_ip_address = true
  key_name = "fh-sandbox"

  vpc_security_group_ids = [
    "sg-0d085d64e2390eacd",
    aws_security_group.k8s_ubu_worker.id
  ]

  tags = {
    Name = "ubu-k8s-worker-0${count.index + 1}"
  }
}

resource "aws_security_group" "k8s_ubu_worker" {
  name = "k8s-ubu-worker"
  description = "Connectivity for k8s manual install"
  vpc_id = "vpc-065b33a8baa73e2a3"

  egress {
    description = "All outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "worker_to_worker" {
  type = "ingress"
  security_group_id = aws_security_group.k8s_ubu_worker.id
  from_port = 0
  to_port = 0
  protocol = -1  
  self = true
}

resource "aws_security_group_rule" "master_to_worker" {
  type = "ingress"
  security_group_id = aws_security_group.k8s_ubu_worker.id
  from_port = 0
  to_port = 0
  protocol = -1  
  source_security_group_id = aws_security_group.k8s_ubu_master.id
}

# This allows public access to the API server
resource "aws_security_group" "k8s_ubu_master" {
  name = "k8s-ubu-master"
  description = "Connectivity for k8s manual install"
  vpc_id = "vpc-065b33a8baa73e2a3"

  # Required if using network load balancer. Maybe switch to ALB?
  ingress {
    description = "Public API access"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "master_to_master" {
  type = "ingress"
  security_group_id = aws_security_group.k8s_ubu_master.id
  from_port = 0
  to_port = 0
  protocol = -1  
  self = true
}

resource "aws_security_group_rule" "worker_to_master" {
  type = "ingress"
  security_group_id = aws_security_group.k8s_ubu_master.id
  from_port = 0
  to_port = 0
  protocol = -1  
  source_security_group_id = aws_security_group.k8s_ubu_worker.id
}
