module "globalVarModule" {

  source = "../../Modules/globalVar"
  variableMap = var.variableMap
  globalSSMParamName = var.globalSSMParamName
}