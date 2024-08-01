terraform {
  backend "s3" {}
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_iam_role" "whatsapp_converter_task_execution_role" {
  name               = "${var.project}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.whatsapp_converter_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role_policy.arn
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"
}

resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.whatsapp_converter_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

 network_configuration {
    subnets         = data.aws_subnets.default.ids
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "whatsapp_converter_log_group" {
  name = "/ecs/${var.project}"
}

resource "aws_ecs_task_definition" "whatsapp_converter_task_definition" {
  family = var.project
  cpu = 256
  memory = 512
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.whatsapp_converter_task_execution_role.arn

  container_definitions = <<EOF
  [
    {
      "name": "${var.project}",
      "image": "https://hub.docker.com/_/hello-world",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${var.region}",
          "awslogs-group": "/ecs/${var.project}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}


# https://section411.com/2019/07/hello-world/
# "image": "hub.docker.com/r/nginxdemos/hello:latest",