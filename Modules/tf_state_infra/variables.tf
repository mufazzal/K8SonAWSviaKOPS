variable "bucketName" {
  #description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "dynamoDbTableName" {
  #description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = null
}