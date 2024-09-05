variable "region" {
  description = "The AWS region"
  type        = string
}

variable "service_name" {
  description = "The name of the api service"
  type        = string
}

variable "uri" {
  description = "The uri used in the api gateway service integration"
  type        = string
}
