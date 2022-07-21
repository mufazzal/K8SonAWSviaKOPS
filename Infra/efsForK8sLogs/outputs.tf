output "efs_id" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.efs_id
}

output "efs_arn" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.efs_arn
}

output "efs_dns_name" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.efs_dns_name
}

output "efs_number_of_mount_targets" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.efs_number_of_mount_targets
}

output "efs_size_in_bytes" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.efs_size_in_bytes
}

output "mt_sg_id" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.mt_sg_id
}

output "mt_ids" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.mt_ids
}

output "mt_dns_names" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.mt_dns_names
}

output "mt_availability_zone_ids" {
  description = "ID of the VPC"
  value       = module.EFS_K8s_Logs.mt_availability_zone_ids
}