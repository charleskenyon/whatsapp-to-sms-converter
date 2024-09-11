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

locals {
  log_group_prefix = "/ecs/${var.project}"
}

module "cloudmap" {
  source = "../../modules/cloudmap"

  service_name = var.project
}

module "api" {
  source = "../../modules/api-gateway"

  service_name                  = "${var.project}-api"
  service_discovery_service_arn = module.cloudmap.service_discovery_service_arn
  region                        = var.region
  subnet_ids                    = data.aws_subnets.default.ids
  vpc_id                        = data.aws_vpc.default.id
}

module "fargate_cluster" {
  source = "../../modules/fargate-cluster"

  project                        = var.project
  vpc_id                         = data.aws_vpc.default.id
  subnet_ids                     = data.aws_subnets.default.ids
  container_port                 = 80
  enable_spot                    = true
  cloudmap_service_discovery_arn = module.cloudmap.service_discovery_service_arn
  desired_count                  = 1
  execution_role_arn             = aws_iam_role.whatsapp_converter_task_execution_role.arn
  task_role_arn                  = aws_iam_role.whatsapp_converter_task_role.arn
  cloudwatch_log_group_prefix    = local.log_group_prefix
  # - SourceSecurityGroupId: !ImportValue VpcLinkSecurityGroup

  container_definition = jsonencode(
    [
      {
        "name" : var.project,
        "image" : var.container_image,
        "portMappings" : [
          {
            "containerPort" : var.container_port
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-region" : var.region,
            "awslogs-group" : local.log_group_prefix,
            "awslogs-stream-prefix" : "ecs"
          }
        },
        "environment" : [
          {
            name  = "WHATSAPP_MEDIA_BUCKET"
            value = aws_s3_bucket.whatsapp_media_bucket.id
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


