variable "region" {
  description = "The AWS region"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "container_port" {
  description = "The TCP port the container is listening on."
  type        = number
  default     = 80
}

variable "container_image" {
  description = "The Docker image to use for the ECS task."
  type        = string
  default     = "nginxdemos/hello"
}

variable "state_bucket" {
  description = "The S3 state bucket name."
  type        = string
}

variable "email" {
  description = "The email to send messages to."
  type        = string
}
