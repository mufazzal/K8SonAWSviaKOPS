variable "dependencyStacks" {
  description = "Name to be used on all the resources as identifier"
  type = set(string)
  default = []
}

# variable "region" {
#   description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
#   type        = string
#   default     = ""
# }

# variable "stateFileBucket" {
#   description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
#   type        = string
#   default     = ""
# }

# variable "stateFileCommonPrefix" {
#   description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
#   type        = string
#   default     = ""
# }


variable "ssmParamNameOfGV" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = ""
}