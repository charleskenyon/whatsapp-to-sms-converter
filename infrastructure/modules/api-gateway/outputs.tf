output "api_gateway_url" {
  description = "The URL of the API Gateway service."
  value       = "https://${aws_apigatewayv2_api.example_api.id}.execute-api.${var.region}.amazonaws.com/${aws_apigatewayv2_stage.example_stage.name}"
}
