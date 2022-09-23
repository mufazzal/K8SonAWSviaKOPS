module "hostZoneImpl" {
  source = "../hostZone"
  zoneName = var.zoneName
  vpc_id = module.networkCompsImpl.vpc_id
}