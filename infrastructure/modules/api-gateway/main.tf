resource "aws_api_gateway_rest_api" "example_api" {
  name = var.service_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "ANY"
  type        = "HTTP"
  uri         = var.uri
}

resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on = [aws_api_gateway_integration.proxy_integration]
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name = "prod"
}
