resource "aws_route53_zone" "private" {
  name = local.dns_zone

  vpc {
    vpc_id = aws_vpc.main.id
  }
}
