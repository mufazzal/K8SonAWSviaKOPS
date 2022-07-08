output "dependencyStacks" {
  description = "ID of the VPC"  
  # value = [for k, stacks in data.terraform_remote_state.stateMap :  stacks.outputs] #stacks.outputs
 
  value = data.terraform_remote_state.stateMap
}

output "gv" {
  description = "ID of the VPC"
  value       = local.gv
}
