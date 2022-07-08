variable "env" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "namePrefix" {
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

variable "iamRoleName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

# variable "ssm_of_ami_name" {
#   description = "Name to be used on all the resources as identifier"
#   type        = string
#   default     = ""
# }

variable "amiId" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "launchTemplateName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "instanceType" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "sshKeyName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
variable "userDataFilePath" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "userDataParamMap" {
  description = "Name to be used on all the resources as identifier"
  type        = map
  default     = {}
}


variable "update_launch_template_default_version" {
  description = "Name to be used on all the resources as identifier"
  type        = bool
  default     = false
}


