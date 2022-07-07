output "kops_bucket_arn" {
  description = "ID of the VPC"
  value       = aws_route53_zone.privateK8sZone.arn
}