terraform {
  backend "s3" {}
}

resource "aws_ecr_repository" "whatsapp_converter_image_respository" {
  name = var.project

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  repository = aws_ecr_repository.whatsapp_converter_image_respository.name

  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only the last ${var.untagged_images} untagged images.",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "imageCountMoreThan",
          "countNumber" : tonumber(var.untagged_images)
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

output "image_url_latest" {
  value       = "${aws_ecr_repository.whatsapp_converter_image_respository.repository_url}:latest"
  description = "The latest whatsapp converter service image url"
}
