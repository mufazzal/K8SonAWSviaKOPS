module "K8sKopsPlatformEC2Image" {

  source = "../../Modules/EC2ImageBuilder"
  prefix = var.prefix
  pipelineName = var.pipelineName
  sshKeyName = var.sshKeyName

  vpc_id  = module.dataMatrix.ds.kopsk8shnNetwork.outputs.vpc_id
  subnet_id = module.dataMatrix.ds.kopsk8shnNetwork.outputs.maintSubnets[0]

  logBucketName = var.logBucketName
  logBucketPrefix = var.logBucketPrefix

  sgName = var.sgName
  sg_ingress_rules = var.sg_ingress_rules  
  sg_egress_rules = var.sg_egress_rules  

  componentFileName = "components/requiredDependencies.yaml"

  imb_version = var.imb_version
}

module "dataMatrix" {
  source = "../dataMatrixDevops"
  dependencyStacks = ["kopsk8shnNetwork"]
}