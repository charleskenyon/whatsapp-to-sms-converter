resource "aws_lb_target_group" "example_alb_target_group" {
  name        = "${var.project}-alb-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    path     = "/health"
    interval = 100
  }

  depends_on = [aws_alb.example_alb]
}

resource "aws_alb" "example_alb" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnet_ids

  security_groups = [
    aws_security_group.example_alb_security_group.id,
  ]
}

resource "aws_alb_listener" "example_alb_listener" {
  load_balancer_arn = aws_alb.example_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_alb_target_group.arn
  }

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.example_alb_target_group]
  }
}

resource "aws_security_group" "example_alb_security_group" {
  name   = "${var.project}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
