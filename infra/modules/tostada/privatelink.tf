resource "aws_lb" "privatelink" {
  enable_cross_zone_load_balancing = false
  internal                         = true
  load_balancer_type               = "network"
  name                             = "tostada-privatelink-nlb"
  subnets                          = data.aws_subnets.service_provider_private.ids
}

resource "aws_lb_target_group" "privatelink" {
  name        = "tostada-privatelink-tg"
  port        = 443
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = data.aws_vpc.service_provider.id
}

resource "aws_lb_target_group_attachment" "privatelink" {
  port             = 443
  target_group_arn = aws_lb_target_group.privatelink.arn
  target_id        = aws_lb.tostada.arn
}

resource "aws_lb_listener" "privatelink" {
  load_balancer_arn = aws_lb.privatelink.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.privatelink.arn
  }
}


resource "aws_vpc_endpoint_service" "privatelink" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.privatelink.arn]
  private_dns_name           = "tostada.${local.private_domain_name}"
}

resource "aws_route53_record" "privatelink" {
    zone_id = data.aws_route53_zone.public.zone_id
    name = "${aws_vpc_endpoint_service.privatelink.private_dns_name_configuration[0]["name"]}."
    type = "TXT"
    ttl  = "300"
    records = [aws_vpc_endpoint_service.privatelink.private_dns_name_configuration[0]["value"]]
}


resource "aws_vpc_endpoint_service_allowed_principal" "allowed_aws_accounts" {
  for_each = toset(var.allowed_aws_accounts_list)

  vpc_endpoint_service_id = aws_vpc_endpoint_service.privatelink.id
  principal_arn           = "arn:aws:iam::${each.key}:root"
}
