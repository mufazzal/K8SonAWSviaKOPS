module "sSMRunCommandExecutorLmabdaImpl" {
  source = "../Lambdas/SSMRunCommandExecutor"
  prefix = var.namePrefix
  lambdaName = "sSMRunCommandExecutor"
  sourceCodeDir = "${local.localLambdaSourceCodeDir}/clutserCommandExecutor/src"
  tmpDirectory = var.tmpDirectory
  bucket_id = module.wp_bucket.bucket_id
  bucketPartitionForLambdaTempSourceCode = var.bucketPartitionForLambdaTempSourceCode
  handler = "index.clutserCommandExecutor"  
  envVariables = {
    dummy = "uu"
  }
  apiGateway_id = module.apiGatewayImpl.apigateway_id
  apiGateway_execution_arn = module.apiGatewayImpl.apigateway_execution_arn
  http_methode = "DELETE"
  http_path = "execute"
}