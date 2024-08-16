variable "region" {
  description = "The AWS region"
  type        = string
}

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "untagged_images" {
  description = "The amount of untagged images to store in ecr before removing oldest"
  type        = string
}
