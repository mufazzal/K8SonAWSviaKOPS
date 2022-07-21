provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "muf-terraform-sate-devops"
    key    = "devops/k8sHN/states/efsK8sLogs.tfstate"
    region = "us-east-1"
    # dynamodb_table = "muf-terraform-sate-lock-dev"
  }
}


# terraform {
#   backend "s3" {
#     bucket = local._bucket #"muf-terraform-sate-dev"
#     key    = "${local.common_prefox}globalVar.tfstate" #"simplewebserver/dev/states/globalVar.tfstate"
#     region = local._region #"us-east-1"
#     dynamodb_table = local.dynamodb_table # "muf-terraform-sate-lock-dev"
#   }
# }

# locals {
#   _bucket = "muf-terraform-sate-dev"
#   _region = "us-east-1"
#   common_prefox = "simplewebserver/dev/states/"
#   dynamodb_table = "muf-terraform-sate-lock-dev"
# }