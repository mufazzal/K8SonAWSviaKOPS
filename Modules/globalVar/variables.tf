variable "variableMap" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = list(object({
    key = string
    value = any
  }))
  default     = []
}


variable "globalSSMParamName" {
  description = "List of allowed AWS account ids where resources can be created"
  type        = string
  default     = ""
}