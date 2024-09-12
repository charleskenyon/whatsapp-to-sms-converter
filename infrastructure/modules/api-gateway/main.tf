resource "aws_apigatewayv2_api" "example_api" {
  name = var.service_name

  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
  }
}

# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.example_api.id
#   parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.example_api.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "proxy_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.example_api.id
#   resource_id             = aws_api_gateway_resource.proxy.id
#   http_method             = aws_api_gateway_method.proxy_method.http_method
#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   uri                     = var.uri
# }

# resource "aws_api_gateway_deployment" "example_deployment" {
#   depends_on  = [aws_api_gateway_integration.proxy_integration]
#   rest_api_id = aws_api_gateway_rest_api.example_api.id
#   stage_name  = "prod"
# }

resource "aws_apigatewayv2_vpc_link" "example_vpc_link" {
  name               = "${var.service_name}-vpc-link"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.example_vpc_link_sg.id]
}

resource "aws_security_group" "example_vpc_link_sg" {
  name_prefix = "${var.service_name}-vpc-link-sg"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from API Gateway IP ranges
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the integration with the ECS service via private DNS
resource "aws_apigatewayv2_integration" "example_integration" {
  api_id             = aws_apigatewayv2_api.example_api.id
  integration_type   = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  integration_method = "ANY"
  integration_uri    = var.service_discovery_service_arn
  connection_id      = aws_apigatewayv2_vpc_link.example_vpc_link.id
}

# Define a route for the API Gateway
resource "aws_apigatewayv2_route" "example_route" {
  api_id    = aws_apigatewayv2_api.example_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.example_integration.id}"
}

resource "aws_apigatewayv2_stage" "example_stage" {
  api_id      = aws_apigatewayv2_api.example_api.id
  auto_deploy = true
  name        = "$default"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.example_log_group.arn
    format = jsonencode({
      requestId        = "$context.requestId",
      ip               = "$context.identity.sourceIp",
      method           = "$context.httpMethod",
      routeKey         = "$context.routeKey",
      status           = "$context.status",
      latency          = "$context.integration.latency"
      error            = "$context.error.message"
      integrationError = "$context.integration.integrationErrorMessage"
      responseType     = "$context.error.responseType"
      protocol         = "$context.protocol"
    })
  }

  default_route_settings {
    detailed_metrics_enabled = true
    logging_level            = "INFO"
    throttling_rate_limit    = 50
    throttling_burst_limit   = 100
  }
}

resource "aws_cloudwatch_log_group" "example_log_group" {
  name              = "/aws/apigateway/${var.service_name}"
  retention_in_days = 1
}

# generate certificate and verify in express that connections only come from api gateway
# https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-client-side-ssl-authentication.html
