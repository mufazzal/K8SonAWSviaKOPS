output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}
output "subnet_for_installer" {
  description = "ID of the VPC"
  value       = module.network.public_subnets[0]
}

output "maintSubnets" {
  description = "ID of the VPC"
  value       = module.network.public_subnets
}


# maintSubnets = [
#   "subnet-0491d80abfc58830e",
#   "subnet-0491ef27df1012bda",
#   "subnet-0d99025ad2ecb7205",
# ]
