resource "aws_security_group" "alb" {
  name   = "alb_ECS"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "udp_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

# GRupo de segurança responsalvel pela config de rede privada, só irá aceitar entrada do nosso ALB
resource "aws_security_group" "private" {
  name   = "private_ECS"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "entry_ECS" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id # Só aceita request da rede do ALB que criamos na primeira linha
  security_group_id        = aws_security_group.private.id
}


resource "aws_security_group_rule" "exit_ECS" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}