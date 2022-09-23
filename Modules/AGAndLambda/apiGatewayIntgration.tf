resource "aws_apigatewayv2_integration" "apigateway_integration" {
  api_id = var.apiGateway_id  # aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "apigateway_integration_route" {
  api_id = var.apiGateway_id # aws_apigatewayv2_api.lambda.id

  route_key = "${var.http_methode} /${var.http_path}"
  target    = "integrations/${aws_apigatewayv2_integration.apigateway_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.apiGateway_execution_arn}/*/*"
}