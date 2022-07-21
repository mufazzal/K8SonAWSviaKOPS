output "efs_id" {
  description = "ID of the VPC"
  value       = aws_efs_file_system.efs.id
}

output "efs_arn" {
  description = "ID of the VPC"
  value       = aws_efs_file_system.efs.arn
}

output "efs_dns_name" {
  description = "ID of the VPC"
  value       = aws_efs_file_system.efs.dns_name
}

output "efs_number_of_mount_targets" {
  description = "ID of the VPC"
  value       = aws_efs_file_system.efs.number_of_mount_targets
}

output "efs_size_in_bytes" {
  description = "ID of the VPC"
  value       = aws_efs_file_system.efs.size_in_bytes 
}

output "mt_sg_id" {
  description = "ID of the VPC"
  value       = aws_security_group.customSg.id
}

output "mt_sg_arn" {
  description = "ID of the VPC"
  value       = aws_security_group.customSg.arn
}

#=-----

output "mt_ids" {
  value = ["${aws_efs_mount_target.efs_mt.*.id}"]
}

output "mt_dns_names" {
  value = ["${aws_efs_mount_target.efs_mt.*.dns_name}"]
}

output "mt_availability_zone_ids" {
  value = ["${aws_efs_mount_target.efs_mt.*.availability_zone_id}"]
}