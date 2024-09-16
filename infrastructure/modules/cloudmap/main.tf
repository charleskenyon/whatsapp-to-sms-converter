data "aws_vpc" "default" {
  default = true
}

resource "aws_service_discovery_private_dns_namespace" "example_namespace" {
  name = "${var.service_name}.com"
  vpc  = data.aws_vpc.default.id
}

resource "aws_service_discovery_service" "example_service_discovery" {
  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.example_namespace.id
    dns_records {
      type = var.record_type
      ttl  = var.record_ttl

    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
