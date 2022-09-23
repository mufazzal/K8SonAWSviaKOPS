module "KopsInstallerEC2LT" {
  source = "../../../Modules/EC2ConfigurationResources"

  env = var.env
  namePrefix = var.namePrefix

  vpc_id  = var.vpc_id
  subnet_id = var.subnet_id
  amiId = var.amiId

  launchTemplateName = var.launchTemplateName

  sgName = var.sgName
  sg_ingress_rules =  var.sg_ingress_rules
  sg_egress_rules = var.sg_egress_rules

  iamRoleName = var.iamRoleName

  instanceType = var.instanceType
  sshKeyName = var.sshKeyName

  userDataFilePath = var.userDataFilePath #"userData.sh"
  userDataParamMap = {
    vpcId: var.vpc_id,
    state_bucket: var.kops_state_bucket,
    cluster_name: var.kops_cluster_name
    scriptRoot = var.scriptRoot
  }  
  update_launch_template_default_version = true
}



