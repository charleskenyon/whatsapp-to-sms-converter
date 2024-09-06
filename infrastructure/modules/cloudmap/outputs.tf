output "service_discovery_name" {
  description = "The name of the service discovery service"
  value       = aws_service_discovery_service.example_service_discovery.name
}

output "service_discovery_dns_namespace" {
  description = "The service discovery service dns namespace"
  value       = aws_service_discovery_private_dns_namespace.example_namespace.name
}

output "service_discovery_service_arn" {
  description = "The ARN of the service discovery service"
  value = aws_service_discovery_service.example_service_discovery.arn
}
