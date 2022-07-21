variable "creation_token" {
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

variable "mtHostingSubnets" {
  description = "Name to be used on all the resources as identifier"
  type        = list(string)
  default     = []
}