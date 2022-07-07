module "KopsPrivateZone" {

  source = "../../Modules/kopsPrivateZone"
  zoneName = var.zoneName
  vpc_id = var.vpc_id
}