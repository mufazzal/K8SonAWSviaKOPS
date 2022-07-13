output "runDoc_latest_version" {
  description = "ID of the VPC"
  value       = aws_ssm_document.runDoc.latest_version
}

output "runDoc_default_version" {
  description = "ID of the VPC"
  value       = aws_ssm_document.runDoc.default_version
}

output "runDoc_document_version" {
  description = "ID of the VPC"
  value       = aws_ssm_document.runDoc.document_version
}