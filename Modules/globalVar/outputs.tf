# output "variableMap" {
#   description = "Global Variables"
#    value = zipmap(var.variableMap.*.key, var.variableMap.*.value)
# }

output "globalVariableSSM_arn" {
  description = "ID of the VPC"
  value       = aws_ssm_parameter.globalVariableSSM.arn
}

  # dynamic "ingress" {
  #   for_each = var.sg_ingress_rules
  #   content {
  #     from_port = ingress.value.from_port
  #     to_port   = ingress.value.to_port
  #     protocol  = ingress.value.protocol
  #     cidr_blocks = [ingress.value.cidr_block]
  #     # security_groups = [ingress.sgId]      
  #   }
  # }