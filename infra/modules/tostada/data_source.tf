data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:VPC-Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
  filter {
    name   = "tag:VPC-Name"
    values = [local.vpc_name]
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "*.${local.private_domain_name}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "private" {
  name         = "${local.private_domain_name}."
  private_zone = true
}

data "aws_route53_zone" "public" {
  name         = "${var.public_domain_name}."
  private_zone = false
}
