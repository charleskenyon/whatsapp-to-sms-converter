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
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.example_integration.id}"
}

resource "aws_apigatewayv2_stage" "example_stage" {
  api_id      = aws_apigatewayv2_api.example_api.id
  auto_deploy = true
  name        = "prod"
}


# resource "aws_subnet" "private_subnet" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "private-subnet"
#   }
# }

# create private subnet
