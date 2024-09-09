variable "project" {
  description = "The name of the project"
  type        = string
}

variable "container_port" {
  description = "The TCP port on which the container receives traffic."
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

variable "enable_spot" {
  description = "Enable Fargate Spot."
  type        = bool
  default     = true
}

variable "load_balancer_target_group_arn" {
  description = "The ARN of a load balancer target group to associate to the ECS service."
  type        = string
  default     = null
}

variable "cloudmap_service_discovery_arn" {
  description = "The Cloupmap service discovery ARN used to map the containers IPs"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "The amount of containers that the service should launch"
  type        = number
  default     = 0
}

variable "container_definition" {
  description = "JSON container definition."
  type        = string
}

variable "execution_role_arn" {
  description = "The IAM execution role arn."
  type        = string
}

variable "task_role_arn" {
  description = "The IAM task role arn."
  type        = string
}

variable "frontend_security_group_id" {
  description = "The frontend security group to lock down incomming traffic to the ecs service security from."
  type        = string
  default     = null
}

variable "cloudwatch_log_group_prefix" {
  description = "The Cloudwatch log group prefix where logs for the container service will be stored."
  type        = string
}
