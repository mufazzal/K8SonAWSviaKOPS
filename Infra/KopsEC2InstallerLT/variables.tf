variable "env" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "jic_namePrefix" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "jic_sgName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "sg_ingress_rules" {
    type        = map
    default     = {}
}

variable "sg_egress_rules" {
    type        = map
    default     = {}
}

variable "jic_iamRoleName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "jic_instanceType" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "jic_sshKeyName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}