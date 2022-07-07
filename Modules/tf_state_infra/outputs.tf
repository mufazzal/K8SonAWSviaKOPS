output "bucketArn" {
  description = "Arn of terafform state Bucket"
  value = aws_s3_bucket.terraform_state.arn
}

output "tableArn" {
  description = "Dynamo DB table arn for state locking"
  value = length(aws_dynamodb_table.terraform_state_lock) > 0 ? aws_dynamodb_table.terraform_state_lock[0].arn : null
}
