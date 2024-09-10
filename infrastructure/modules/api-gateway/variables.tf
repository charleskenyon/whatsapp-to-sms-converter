variable "region" {
  description = "The AWS region"
  type        = string
}

variable "service_name" {
  description = "The name of the api service"
  type        = string
}

variable "vpc_id" {
  description = "The id of the vpc in which to deploy the ALB."
  type        = string
}

variable "subnet_ids" {
  description = "The ids of the subnets in which to deploy the ALB."
  type        = list(string)
}

variable "service_discovery_service_arn" {
  description = "The Cloud Map service ARN."
  type        = string
}
