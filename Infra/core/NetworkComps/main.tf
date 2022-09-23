module "network" {
  source = "../../../Modules/KopsK8sAwsNetworkComp"
  name = var.name
  cidr = var.cidr
  azs  = var.azs
  public_subnets = var.subnet_for_installer  
}