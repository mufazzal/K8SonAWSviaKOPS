locals {
  scriptRoot = "https://${module.wp_bucket.bucket_id}.s3.amazonaws.com/Scripts"
  localLambdaSourceCodeDir = "C:/CodeTreasury/Projects/AWSKOPS_manager_lambdas"
}
