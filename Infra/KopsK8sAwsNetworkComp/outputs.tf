output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}
output "subnet_for_installer" {
  description = "ID of the VPC"
  value       = module.network.public_subnets[0]
}


