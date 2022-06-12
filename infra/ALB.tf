resource "aws_lb" "alb" {
  name            = "ECS-SaudeTv"
  security_groups = [aws_security_group.alb.id]
  subnets         = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_lb_target_group" "target" {
  name        = "ECS-SaudeTv"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "api.saudetvpainel.com.br"
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "IP" {
  value = aws_lb.alb.dns_name
}
