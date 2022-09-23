module "networkCompsImpl" {
  source = "../NetworkComps"
  name = var.networkComps_vpc_name
  cidr = var.networkComps_vpc_cidr
  azs  = var.networkComps_azs
  subnet_for_installer = var.networkComps_subnet_for_installer  
}