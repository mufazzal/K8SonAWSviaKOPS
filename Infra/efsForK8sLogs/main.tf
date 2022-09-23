module "EFS_K8s_Logs" {

  source = "../../Modules/EFS"
  creation_token = var.creation_token
  sg_ingress_rules = var.sg_ingress_rules
  sg_egress_rules = var.sg_egress_rules

  vpc_id  = "vpc-021158bf62c6b829c"
  mtHostingSubnets = ["subnet-09b920002344cc235"]
}

module "dataMatrix" {
  source = "../dataMatrixDevops"
  dependencyStacks = ["kopsk8shnNetwork"]
}