output "api_gateway_url" {
  description = "The URL of the API Gateway service."
  value       = aws_apigatewayv2_api.example_api.api_endpoint
}

output "vpc_link_sg_id" {
  value = aws_security_group.example_vpc_link_sg.id
}
