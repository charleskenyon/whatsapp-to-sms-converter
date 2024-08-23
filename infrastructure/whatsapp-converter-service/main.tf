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

data "terraform_remote_state" "image_repo" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    region = var.region
    key    = "image-repo/terraform.tfstate"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"
}

resource "aws_ecs_service" "whatsapp_converter_service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.whatsapp_converter_task_definition.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.whatsapp_converter_sg_backend.id,
    ]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.whatsapp_converter_alb_target_group.arn
  #   container_name   = var.project
  #   container_port   = var.container_port
  # }
}

resource "aws_cloudwatch_log_group" "whatsapp_converter_log_group" {
  name = "/ecs/${var.project}"
}

resource "aws_ecs_task_definition" "whatsapp_converter_task_definition" {
  family                   = var.project
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.whatsapp_converter_task_execution_role.arn
  task_role_arn            = aws_iam_role.whatsapp_converter_task_role.arn

  container_definitions = jsonencode(
    [
      {
        "name" : var.project,
        "image" : data.terraform_remote_state.image_repo.outputs.image_url_latest,
        "portMappings" : [
          {
            "containerPort" : var.container_port
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-region" : var.region,
            "awslogs-group" : "/ecs/${var.project}",
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "environment" : [
          {
            name  = "WHATSAPP_MEDIA_BUCKET"
            value = aws_s3_bucket.whatsapp_media_bucket.id
          },
          {
            name  = "WHATSAPP_SNS_SMS_TOPIC_ARN",
            value = aws_sns_topic.whatsapp_sms_topic.arn
          },
          {
            name  = "AWS_REGION"
            value = var.region
          }
        ]
      }
    ]
  )
}

output "default_subnet_ips" {
  value       = data.aws_subnets.default.ids
  description = "default subnet ips"
}

output "image" {
  value = data.terraform_remote_state.image_repo.outputs.image_url_latest
}

# https://section411.com/2019/07/hello-world/
# "image": "hub.docker.com/r/nginxdemos/hello:latest",


# https://github.com/Vad1mo/hello-world-rest/tree/master
# "image": hello-world

# https://github.com/joshbeard/terraform-ecs-hello-world/blob/master/ecs.tf

// add load balancer

# https://awsteele.com/blog/2022/10/15/cheap-serverless-containers-using-api-gateway.html


# https://www.linkedin.com/pulse/how-upload-docker-images-aws-ecr-using-terraform-hendrix-roa

# https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/build-and-push-docker-images-to-amazon-ecr-using-github-actions-and-terraform.html

# https://earthly.dev/blog/deploy-dockcontainers-to-awsecs-using-terraform/
