variable "TAG_Stack" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""

}

variable "VAL_K8sHN" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""
}


variable "allResources" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""
}


variable "ssm_doc_installCWAgent" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""
}


variable "CWConfigSSMParam" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""
}
