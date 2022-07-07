resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucketName
  acl    = "public-read"
  
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  count = var.dynamoDbTableName != null ? 1 : 0
  name           = var.dynamoDbTableName
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
