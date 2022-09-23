variable "kopsEC2InstallerLT_sgName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kopsEC2InstallerLT_sg_ingress_rules" {
    type        = map
    default     = {}
}

variable "kopsEC2InstallerLT_sg_egress_rules" {
    type        = map
    default     = {}
}

variable "kopsEC2InstallerLT_iamRoleName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kopsEC2InstallerLT_instanceType" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kopsEC2InstallerLT_sshKeyName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kopsEC2InstallerLT_kopsK8sInstallerCleanAmi" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kopsEC2InstallerLT_launchTemplateName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}
