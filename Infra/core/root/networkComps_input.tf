variable "networkComps_vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "networkComps_vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "networkComps_azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "networkComps_subnet_for_installer" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
