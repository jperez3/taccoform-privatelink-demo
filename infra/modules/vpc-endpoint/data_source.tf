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

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_vpc_endpoint_service" "privatelink" {
  filter {
    name   = "tag:Service"
    values = [var.service]
  }
}
