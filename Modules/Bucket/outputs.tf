output "bucket_arn" {
  description = "ID of the VPC"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_id" {
  description = "ID of the VPC"
  value       = aws_s3_bucket.bucket.id
}