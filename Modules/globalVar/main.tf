resource "aws_ssm_parameter" "globalVariableSSM" {
  name  = var.globalSSMParamName
  type  = "String"
  value = jsonencode(zipmap(var.variableMap.*.key, var.variableMap.*.value))
}