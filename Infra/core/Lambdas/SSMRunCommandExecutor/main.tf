module "SSMRunCommandExecutorLmabda" {
  source = "../../../../Modules/AGAndLambda"
  prefix = var.prefix
  lambdaName = var.lambdaName
  sourceCodeDir = var.sourceCodeDir
  bucket_id = var.bucket_id
  bucketPartitionForLambdaTempSourceCode = var.bucketPartitionForLambdaTempSourceCode
  handler = var.handler
  envVariables = var.envVariables
  tmpDirectory = var.tmpDirectory
  apiGateway_id = var.apiGateway_id
  apiGateway_execution_arn = var.apiGateway_execution_arn
  http_methode = var.http_methode
  http_path = var.http_path  
}