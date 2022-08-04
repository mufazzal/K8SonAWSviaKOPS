variable "prefix" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "pipelineName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "sshKeyName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "logBucketName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "logBucketPrefix" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "sgName" {
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

variable "componentFileName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "imb_version" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
