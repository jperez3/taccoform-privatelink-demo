resource "aws_lb_target_group" "tostada" {
  name     = "tostada"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.service_provider.id
}

resource "aws_lb" "tostada" {
  name               = "tostada"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tostada.id]
  subnets            = data.aws_subnets.service_provider_private.ids


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
