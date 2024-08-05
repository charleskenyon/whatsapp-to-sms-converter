# resource "aws_security_group" "whatsapp_converter_frontend_sg" {
#   name        = "${var.project}-frontend-sg"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     to_port     = 80
#     from_port   = 0
#     protocol    = "tcp"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_lb_target_group" "whatsapp_converter_alb_target_group" {
  name        = "${var.project}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.whatsapp_converter_alb]
}

resource "aws_alb" "whatsapp_converter_alb" {
  name               =  "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_subnets.default.ids

  security_groups = [
    data.aws_security_group.default.id
  ]
}

# aws_security_group.whatsapp_converter_frontend_sg.id

resource "aws_alb_listener" "whatsapp_converter_alb_listener" {
  load_balancer_arn = aws_alb.whatsapp_converter_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.whatsapp_converter_alb_target_group.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.whatsapp_converter_alb.dns_name}"
}