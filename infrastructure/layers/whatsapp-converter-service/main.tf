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
  record_type  = "SRV"
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
  container_port                 = var.container_port
  enable_spot                    = true
  cloudmap_service_discovery_arn = module.cloudmap.service_discovery_service_arn
  desired_count                  = 1
  execution_role_arn             = aws_iam_role.whatsapp_converter_task_execution_role.arn
  task_role_arn                  = aws_iam_role.whatsapp_converter_task_role.arn
  cloudwatch_log_group_prefix    = local.log_group_prefix
  frontend_security_group_id     = module.api.vpc_link_sg_id

  container_definition = jsonencode(
    [
      {
        "name" : var.project,
        "image" : data.terraform_remote_state.image_repo.outputs.image_url_latest,
        # "pseudoTerminal" : true,
        "interactive" : true,
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
            name  = "AWS_REGION"
            value = var.region
          },
          {
            name  = "WHATSAPP_MEDIA_BUCKET"
            value = aws_s3_bucket.whatsapp_media_bucket.id
          },
          {
            name  = "RECEIVING_PHONE_NUMBER"
            value = var.receiving_phone_number
          },
          {
            name  = "TWILIO_AUTH_TOKEN"
            value = var.twilio_auth_token
          },
          {
            name  = "TWILIO_ACCOUNT_SID"
            value = var.twilio_account_sid
          },
          {
            name  = "TWILIO_NUMBER"
            value = var.twilio_number
          },
          {
            name  = "TWILIO_NUMBER_SID"
            value = var.twilio_number_sid
          },
          {
            name  = "CONTAINER_PORT"
            value = tostring(var.container_port)
          }
        ],
        healthCheck = {
          command      = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
          interval     = 30
          timeout      = 5
          retries      = 3
          start_period = 0
        }
      }
    ]
  )
}
