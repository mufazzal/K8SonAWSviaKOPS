module "createClusterLmabdaImpl" {
  source = "../Lambdas/CreateCluster"
  prefix = var.namePrefix
  lambdaName = "createcluster"
  sourceCodeDir = "${local.localLambdaSourceCodeDir}/createCluster/src"
  tmpDirectory = var.tmpDirectory
  bucket_id = module.wp_bucket.bucket_id
  bucketPartitionForLambdaTempSourceCode = var.bucketPartitionForLambdaTempSourceCode
  handler = "index.createCluster"  
  envVariables = {
    launchTemplateName = module.kopsInstallerEC2LTImpl.launchTemplate_name
  }
  apiGateway_id = module.apiGatewayImpl.apigateway_id
  apiGateway_execution_arn = module.apiGatewayImpl.apigateway_execution_arn
  http_methode = "POST"
  http_path = "createCluster"
}