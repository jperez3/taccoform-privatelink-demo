resource "aws_security_group" "tostada" {

  name        = "tostada-${local.vpc_name}"
  description = "${local.vpc_name} tostada security group"
  vpc_id      = data.aws_vpc.service_provider.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.service_provider.cidr_block]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.service_provider.cidr_block]
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

resource "aws_instance" "tostada" {

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t4g.nano"
  subnet_id              = data.aws_subnets.service_provider_private.ids[0]
  vpc_security_group_ids = [aws_security_group.tostada.id]
  user_data              = file("${path.module}/files/user-data.sh")

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "tostada-${local.vpc_name}"
    })
  )
}
