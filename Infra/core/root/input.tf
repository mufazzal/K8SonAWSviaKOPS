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

variable "namePrefixSmallCase" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kops_cluster_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "kops_state_bucket" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "bucketPartitionForLambdaTempSourceCode" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "tmpDirectory" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}