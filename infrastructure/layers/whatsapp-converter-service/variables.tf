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
  default     = 3000
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

variable "receiving_phone_number" {
  description = "The phone number to which the service should send sms notifications."
  type        = string
}

variable "twilio_auth_token" {
  description = "The Twilio auth token."
  type        = string
  sensitive   = true
}

variable "twilio_account_sid" {
  description = "The Twilio account SID."
  type        = string
  sensitive   = true
}

variable "twilio_number" {
  description = "The Twilio number at which the service will receive sms messages."
  type        = string
}
variable "twilio_number_sid" {
  description = "The Twilio number SID."
  type        = string
}
