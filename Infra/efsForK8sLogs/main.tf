module "EFS_K8s_Logs" {

  source = "../../Modules/EFS"
  creation_token = var.creation_token
  sg_ingress_rules = var.sg_ingress_rules
  sg_egress_rules = var.sg_egress_rules

  vpc_id  = module.dataMatrix.ds.kopsk8shnNetwork.outputs.vpc_id
  mtHostingSubnets = module.dataMatrix.ds.kopsk8shnNetwork.outputs.maintSubnets
}

module "dataMatrix" {
  source = "../dataMatrixDevops"
  dependencyStacks = ["kopsk8shnNetwork"]
}