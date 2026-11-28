# What Terraform needs: its own version, and the AWS plugin ("provider")
terraform {
  required_version = ">= 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.74"
    }
  }
}

# Which AWS region to use, and labels ("tags") put on everything Terraform creates
provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Project   = "task-tracker"
      ManagedBy = "terraform"
    }
  }
}

# Find the newest official Ubuntu 24.04 image (099720109477 = Canonical, the company behind Ubuntu)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Your laptop's PUBLIC SSH key, so you can log in to the new server
resource "aws_key_pair" "laptop" {
  key_name   = "task-tracker-tf"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

# The firewall ("security group")
resource "aws_security_group" "web" {
  name        = "task-tracker-tf-sg"
  description = "SSH, HTTP and HTTPS for the Task Tracker server"
}

# Let IN: SSH (22), HTTP (80) and HTTPS (443) from anywhere - one rule per port
resource "aws_vpc_security_group_ingress_rule" "in" {
  for_each = { ssh = 22, http = 80, https = 443 }

  security_group_id = aws_security_group.web.id
  description       = each.key
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = each.value
  to_port           = each.value
}

# Let OUT: everything (updates, Docker images...)
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# The server itself
resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  key_name               = aws_key_pair.laptop.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "task-tracker-2"
  }

  # A newer Ubuntu image comes out every few weeks - don't rebuild the server just for that
  lifecycle {
    ignore_changes = [ami]
  }
}

# ---------- Permanent IP (Elastic IP) ----------
# We made this IP by hand in Step 6. "import" tells Terraform:
# don't create a new IP - adopt (take over) the one that already exists.
import {
  to = aws_eip.web
  id = "eipalloc-0232e29719d0c7d7d"
}

resource "aws_eip" "web" {
  domain = "vpc"

  tags = {
    Name = "task-tracker-ip"
  }

  # DuckDNS points at this IP. Never delete it, even by accident.
  lifecycle {
    prevent_destroy = true
  }
}

# Attach the IP to the new server. If it is on another server,
# move it over in one step (no gap).
resource "aws_eip_association" "web" {
  allocation_id       = aws_eip.web.id
  instance_id         = aws_instance.server.id
  allow_reassociation = true
}
