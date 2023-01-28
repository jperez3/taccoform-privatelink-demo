resource "aws_lb_target_group" "tostada" {
  name     = "tostada"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id
}

resource "aws_lb" "tostada" {
  name               = "tostada"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tostada.id]
  subnets            = data.aws_subnets.private.ids


  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_lb_listener" "tostada" {
  load_balancer_arn = aws_lb.tostada.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tostada.arn
  }
}

resource "aws_lb_target_group_attachment" "tostada" {
  target_group_arn = aws_lb_target_group.tostada.arn
  target_id        = aws_instance.tostada.id
  port             = 80
}


resource "aws_route53_record" "lb_cname" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "tostada.${local.private_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.tostada.dns_name]
}

###############
# PrivateLink #
###############

resource "aws_lb" "privatelink" {
  enable_cross_zone_load_balancing = false
  internal                         = true
  load_balancer_type               = "network"
  name                             = "tostada-privatelink-nlb"
  subnets                          = data.aws_subnets.private.ids
}

resource "aws_lb_target_group" "privatelink" {
  name        = "tostada-privatelink-tg"
  port        = "443"
  protocol    = "TCP"
  target_type = "alb"
  vpc_id      = data.aws_vpc.selected.id

  # health_check {
  #   path     = "/"
  #   port     = "443"
  #   protocol = "HTTPS"
  # }
}

resource "aws_lb_target_group_attachment" "privatelink" {
  port             = 443
  target_group_arn = aws_lb_target_group.privatelink.arn
  target_id        = aws_lb.tostada.arn

  depends_on = [aws_lb_target_group.privatelink]
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

output "vpce_service_id" {
  value = aws_vpc_endpoint_service.privatelink.id
}
