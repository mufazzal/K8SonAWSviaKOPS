resource "aws_security_group" "customSg" {
  name = "${var.prefix}-${var.pipelineName}-SG"
  vpc_id  = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      protocol  = ingress.value.protocol
      cidr_blocks       = ingress.value.cidr_block
      security_groups = ingress.value.security_group_id      
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rules
    content {
      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      protocol  = egress.value.protocol
      cidr_blocks  = [egress.value.cidr_block]
      # security_groups = [ingress.sgId]      
    }
  }  
}