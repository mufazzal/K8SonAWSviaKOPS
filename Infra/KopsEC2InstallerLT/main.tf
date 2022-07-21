module "KopsInstallerEC2LT" {
  source = "../../Modules/EC2ConfigurationResources"

  env = var.env
  namePrefix = var.jic_namePrefix

  vpc_id  = module.dataMatrix.ds.kopsk8shnNetwork.outputs.vpc_id
  subnet_id = module.dataMatrix.ds.kopsk8shnNetwork.outputs.subnet_for_installer
  amiId = module.dataMatrix.gv.KopsK8sInstallerCleanAmi

  sgName = var.jic_sgName
  sg_ingress_rules =  var.sg_ingress_rules
  sg_egress_rules = var.sg_egress_rules

  iamRoleName = var.jic_iamRoleName

  instanceType = var.jic_instanceType
  sshKeyName = var.jic_sshKeyName

  userDataFilePath = "userData.sh"
  userDataParamMap = {
    vpcId: module.dataMatrix.ds.kopsk8shnNetwork.outputs.vpc_id,
    state_bucket: "s3://muf-k8s-kops-state-bucket",
    cluster_name: "hn.k8shn.com"
  }  
  update_launch_template_default_version = true
}

module "dataMatrix" {
  source = "../dataMatrixDevops"
  dependencyStacks = ["kopsk8shnNetwork"]
}


