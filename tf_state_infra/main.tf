provider "aws" {
  region = "us-east-1"
}

module "tf_state_infra" {
  source = "../Modules/tf_state_infra"
  bucketName = var.bucketName
  # dynamoDbTableName = var.dynamoDbTableName
}
