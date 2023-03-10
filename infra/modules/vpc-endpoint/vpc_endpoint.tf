

resource "aws_security_group" "consumer" {
  name        = "tostada-${local.vpc_name}"
  description = "${local.vpc_name} tostada security group"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "tostada-${local.vpc_name}"
    })
  )
}


resource "aws_vpc_endpoint" "privatelink" {
  private_dns_enabled = true # allows custom domain usage instead of AWS provided DNS name
  service_name        = data.aws_vpc_endpoint_service.privatelink.service_name
  security_group_ids  = [aws_security_group.consumer.id]
  subnet_ids          = data.aws_subnets.private.ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.selected.id

}
