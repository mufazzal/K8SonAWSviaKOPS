provider "aws" {
  region = "us-east-1" #local.gv.region
  # allowed_account_ids = var.allowed_account_ids
}

terraform {
  backend "s3" {
    bucket = "muf-terraform-sate-devops"
    key    = "devops/k8sHN/states/kopsk8shnNetwork.tfstate"
    region = "us-east-1"
    # dynamodb_table = "muf-terraform-sate-lock-dev"
  }
}