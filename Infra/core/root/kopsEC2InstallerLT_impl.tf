module "kopsInstallerEC2LTImpl" {
  source = "../KopsEC2InstallerLT"

  env = var.env
  namePrefix = var.namePrefix

  vpc_id  = module.networkCompsImpl.vpc_id
  subnet_id = module.networkCompsImpl.subnet_for_installer
  amiId = var.kopsEC2InstallerLT_kopsK8sInstallerCleanAmi  #module.dataMatrix.gv.KopsK8sInstallerCleanAmi

  launchTemplateName = var.kopsEC2InstallerLT_launchTemplateName

  sgName = var.kopsEC2InstallerLT_sgName
  sg_ingress_rules =  var.kopsEC2InstallerLT_sg_ingress_rules
  sg_egress_rules = var.kopsEC2InstallerLT_sg_egress_rules

  iamRoleName = var.kopsEC2InstallerLT_iamRoleName

  instanceType = var.kopsEC2InstallerLT_instanceType
  sshKeyName = var.kopsEC2InstallerLT_sshKeyName

  kops_state_bucket = var.kops_state_bucket
  kops_cluster_name = var.kops_cluster_name
  scriptRoot = local.scriptRoot
  

  userDataFilePath = "scripts/installer_userData.sh"
}



