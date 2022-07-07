resource "aws_s3_bucket" "kops_bucket" {
  bucket = var.kops_state_bucket_name

  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.kops_bucket.id
  acl    = "public-read-write"
}

