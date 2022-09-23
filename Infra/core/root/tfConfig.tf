terraform {

  required_providers {

    myawsprovider = {
      source  = "hashicorp/aws"
      # version = "~> 1.0.4"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

  } 

  backend "s3" {
    bucket = "muf-terraform-sate-devops"
    key    = "devops/k8sHN/states/core1.tfstate"
    region = "us-east-1"
    # dynamodb_table = "muf-terraform-sate-lock-dev"
  }
}

provider "myawsprovider" {
  region = "us-east-1" #local.gv.region
  # allowed_account_ids = var.allowed_account_ids
}