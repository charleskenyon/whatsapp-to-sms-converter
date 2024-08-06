resource "aws_lb_target_group" "whatsapp_converter_alb_target_group" {
  name        = "${var.project}-alb-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled = true
    path    = "/health"
    interval = 100
  }

  depends_on = [aws_alb.whatsapp_converter_alb]
}

resource "aws_alb" "whatsapp_converter_alb" {
  name               =  "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_subnets.default.ids

  security_groups = [
    aws_security_group.whatsapp_converter_sg_frontend.id,
  ]
}

resource "aws_alb_listener" "whatsapp_converter_alb_listener" {
  load_balancer_arn = aws_alb.whatsapp_converter_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.whatsapp_converter_alb_target_group.arn
  }

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.whatsapp_converter_alb_target_group]
  }
}

output "alb_url" {
  value = "http://${aws_alb.whatsapp_converter_alb.dns_name}"
}