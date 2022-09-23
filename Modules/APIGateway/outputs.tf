output "apigateway_id" {
  description = "ID of the VPC"
  value       = aws_apigatewayv2_api.apigateway.id
}

output "apigateway_execution_arn" {
  description = "ID of the VPC"
  value       = aws_apigatewayv2_api.apigateway.execution_arn
}