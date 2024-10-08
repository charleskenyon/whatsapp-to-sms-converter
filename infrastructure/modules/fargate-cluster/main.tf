resource "aws_ecs_cluster" "example_cluster" {
  name = "${var.project}-cluster"
}

resource "aws_ecs_service" "example_ecs_service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = var.desired_count
  launch_type     = var.enable_spot ? null : "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups = [
      aws_security_group.example_container_security_group.id,
    ]
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.enable_spot[*]
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer_target_group_arn[*]
    content {
      target_group_arn = var.load_balancer_target_group_arn
      container_name   = var.project
      container_port   = var.container_port
    }
  }

  dynamic "service_registries" {
    for_each = var.cloudmap_service_discovery_arn[*]
    content {
      registry_arn = var.cloudmap_service_discovery_arn
      port         = var.container_port
    }
  }
}

resource "aws_cloudwatch_log_group" "example_container_log_group" {
  name = var.cloudwatch_log_group_prefix
}

resource "aws_ecs_task_definition" "example_task_definition" {
  family                   = var.project
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = var.container_definition
}

resource "aws_security_group" "example_container_security_group" {
  name   = "${var.project}-service-security-group"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "example_container_security_group_ingress" {
  security_group_id            = aws_security_group.example_container_security_group.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "TCP"
  referenced_security_group_id = var.frontend_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "example_container_security_group_egress" {
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.example_container_security_group.id
}

