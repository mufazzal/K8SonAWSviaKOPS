resource "aws_apigatewayv2_api" "apigateway" {
  name          = "${var.apiGatewayName}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "GET", "OPTIONS"]
    allow_headers = ["*"]
    max_age = 1000
  }

}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.apigateway.id

  name        = "${var.stageName}"
  auto_deploy = true
}