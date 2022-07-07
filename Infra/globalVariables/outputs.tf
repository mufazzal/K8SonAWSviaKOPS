output "SSM_arn" {
  description = "globalVariableSSM_arn"
  value       = module.globalVarModule.globalVariableSSM_arn
}


# output "globalVariableMap" {
#   description = "globalVariableMap"
#   value       = module.globalVarModule.variableMap
# }

# output "allowed_account_ids" {
#   description = "allowed_account_ids"
#   value       = split(",", module.globalVarModule.variableMap.allowed_account_ids)

# }

# output "openEc2Port" {
#   description = "openEc2Port"
#   value       = tonumber(module.globalVarModule.variableMap.openEc2Port)
# }
