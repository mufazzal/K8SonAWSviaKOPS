output "sg_id" {
  description = "ID of the VPC"
  value       = module.KopsInstallerEC2LT.sg_id
}

output "iamProfile_arn" {
  description = "ID of the VPC"
  value       = module.KopsInstallerEC2LT.iamProfile_arn
}

# output "ami_ssm_name" {
#   description = "ID of the VPC"
#   value       = module.KopsInstallerEC2LT.ami_ssm_name
#   sensitive = true
# }

output "launchTemplate_arn" {
  description = "ID of the VPC"
  value       = module.KopsInstallerEC2LT.launchTemplate_arn
}
output "launchTemplate_id" {
  description = "ID of the VPC"
  value       = module.KopsInstallerEC2LT.launchTemplate_id
}
output "launchTemplate_latest_version" {
  description = "ID of the VPC"
  value       = module.KopsInstallerEC2LT.launchTemplate_latest_version
}

