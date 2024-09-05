output "default_subnet_ips" {
  value       = data.aws_subnets.default.ids
  description = "default subnet ips"
}

output "image" {
  value = data.terraform_remote_state.image_repo.outputs.image_url_latest
}
