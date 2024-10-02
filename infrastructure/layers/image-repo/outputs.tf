output "repository_url" {
  value       = aws_ecr_repository.whatsapp_converter_image_respository.repository_url
  description = "The ECR repository url"
}

output "image_url_latest" {
  value       = "${aws_ecr_repository.whatsapp_converter_image_respository.repository_url}:latest"
  description = "The latest whatsapp converter service image url"
}
