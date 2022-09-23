resource "aws_s3_bucket" "PortalSiteWWWBucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.PortalSiteWWWBucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.PortalSiteWWWBucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}


resource "aws_s3_bucket_acl" "bucketAcl" {
  bucket = aws_s3_bucket.PortalSiteWWWBucket.id
  acl    = "public-read-write"
}