output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "ID of the VPC"
  value       = module.vpc.public_subnets
}