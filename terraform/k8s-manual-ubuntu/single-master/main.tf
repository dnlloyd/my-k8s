variable "worker_count" {
  default = 1
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
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.small" # Do not use smaller than a t3.small
  associate_public_ip_address = true
  key_name = "fh-sandbox"

  vpc_security_group_ids = [
    "sg-0d085d64e2390eacd",
    aws_security_group.k8s_ubu_master.id
  ]

  tags = {
    Name = "ubu-k8s-master"
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
    Name = "ubu-k8s-worker-0${var.worker_count}"
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

# This allows public access to the API server
resource "aws_security_group" "k8s_ubu_master" {
  name = "k8s-ubu-master"
  description = "Connectivity for k8s manual install"
  vpc_id = "vpc-065b33a8baa73e2a3"

  ingress {
    description = "Worker to master"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    security_groups = [aws_security_group.k8s_ubu_worker.id]
  }

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
