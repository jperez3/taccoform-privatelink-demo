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

data "aws_vpc" "service_provider" {
  filter {
    name   = "tag:Name"
    values = [local.provider_vpc_name]
  }
}

data "aws_subnets" "service_provider_private" {
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
  filter {
    name   = "tag:VPC-Name"
    values = [local.provider_vpc_name]
  }
}

data "aws_vpc" "service_consumer" {
  filter {
    name   = "tag:Name"
    values = [local.consumer_vpc_name]
  }
}

data "aws_subnets" "service_consumer_private" {
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
  filter {
    name   = "tag:VPC-Name"
    values = [local.consumer_vpc_name]
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