provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = var.project
      Stack   = "whatsapp-converter-service"
    }
  }
}
