variable "prefix" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "lambdaName" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "sourceCodeDir" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "bucket_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "bucketPartitionForLambdaTempSourceCode" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "handler" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "envVariables" {
  description = "Name to be used on all the resources as identifier"
  type        = map
  default     = {}
}

variable "tmpDirectory" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "apiGateway_id" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "apiGateway_execution_arn" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}


variable "http_methode" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "http_path" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}