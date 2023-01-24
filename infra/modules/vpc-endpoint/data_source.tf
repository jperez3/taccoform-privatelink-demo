data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
  filter {
    name   = "tag:VPC-Name"
    values = [var.vpc_name]
  }
}

data "aws_vpc_endpoint_service" "privatelink" {
  filter {
    name   = "tag:Service"
    values = [var.service]
  }
}
