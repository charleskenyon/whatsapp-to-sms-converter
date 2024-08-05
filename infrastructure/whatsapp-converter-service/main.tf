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

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"

}

resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.whatsapp_converter_task_definition.arn
  desired_count   = 0
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
      "image": "vad1mo/hello-world-rest",
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

output "default_subnet_ips" {
  value       = data.aws_subnets.default.ids
  description = "default subnet ips"
}

output "default_igw_id" {
  value       = data.aws_internet_gateway.default.id
  description = "default internet gateway id"
}

# https://section411.com/2019/07/hello-world/
# "image": "hub.docker.com/r/nginxdemos/hello:latest",


# https://github.com/Vad1mo/hello-world-rest/tree/master
# "image": hello-world

# https://github.com/joshbeard/terraform-ecs-hello-world/blob/master/ecs.tf

// add load balancer