output "bucketArn" {
  description = "Arn of terafform state Bucket"
  value       = module.tf_state_infra.bucketArn
}

output "tableArn" {
  description = "Dynamo DB table arn for state locking"
  value       = module.tf_state_infra.tableArn
}