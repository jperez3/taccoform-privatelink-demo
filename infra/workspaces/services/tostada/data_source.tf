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
    name   = "tag:VPC-Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "service_provider_private" {
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
  domain   = "*.${local.vpc_name}.${var.public_domain_name}"
  statuses = ["ISSUED"]
}
