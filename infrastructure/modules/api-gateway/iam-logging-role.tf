resource "aws_iam_role" "example_logging_role" {
  name = "${var.service_name}-api-gateway-logging-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy" "api_gateway_managed_logging_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


resource "aws_iam_role_policy_attachment" "example_cloudwatch_policy_attachment" {
  role       = aws_iam_role.example_logging_role.name
  policy_arn = data.aws_iam_policy.api_gateway_managed_logging_policy.arn
}
