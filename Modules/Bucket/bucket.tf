resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucketAcl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_policy" "allow_access_to_all_for_SSMoutput" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"SimulateFolderACL",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
        "Resource":["${aws_s3_bucket.bucket.arn}/workspace/ssmCommandOutputs/*"]
        }
    ]
}
EOF  
}
