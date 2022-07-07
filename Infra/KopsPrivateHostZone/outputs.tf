output "pz_arn" {
  description = "bucket_arn"
  value       = module.KopsPrivateZone.kops_bucket_arn
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
