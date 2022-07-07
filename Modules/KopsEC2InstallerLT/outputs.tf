output "sg_id" {
  description = "ID of the VPC"
  value       = aws_security_group.customSg.id
}

output "sg_arn" {
  description = "ID of the VPC"
  value       = aws_security_group.customSg.arn
}



output "iamRole_id" {
  description = "ID of the VPC"
  value       = aws_iam_role.iamRole.id
}

output "iamRole_arn" {
  description = "ID of the VPC"
  value       = aws_iam_role.iamRole.arn
}

output "iamRole_name" {
  description = "ID of the VPC"
  value       = aws_iam_role.iamRole.name
}

output "iamProfile_id" {
  description = "ID of the VPC"
  value       = aws_iam_instance_profile.iamProfile.id
}

output "iamProfile_arn" {
  description = "ID of the VPC"
  value       = aws_iam_instance_profile.iamProfile.arn
}

# output "ami_ssm_arn" {
#   description = "ID of the VPC"
#   value       = aws_ssm_parameter.ami_ssm.arn
# }

# output "ami_ssm_name" {
#   description = "ID of the VPC"
#   value       = aws_ssm_parameter.ami_ssm.name
# }

output "launchTemplate_arn" {
  description = "ID of the VPC"
  value       = aws_launch_template.launchTemplate.arn
}

output "launchTemplate_id" {
  description = "ID of the VPC"
  value       = aws_launch_template.launchTemplate.id
}

output "launchTemplate_latest_version" {
  description = "ID of the VPC"
  value       = aws_launch_template.launchTemplate.latest_version
}

