variable "region" {
  description = "The AWS region"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "container_port" {
  description = "The TCP port on which the targets receive traffic."
  type        = number
  default     = 80
}

variable "vpc_id" {
  description = "The id of the vpc in which to deploy the ALB."
  type        = string
}

variable "subnet_ids" {
  description = "The ids of the subnets in which to deploy the ALB."
  type        = list(string)
}
