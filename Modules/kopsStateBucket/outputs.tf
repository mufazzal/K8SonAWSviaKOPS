output "kops_bucket_arn" {
  description = "ID of the VPC"
  value       = aws_s3_bucket.kops_bucket.arn
}