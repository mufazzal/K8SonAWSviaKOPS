resource "aws_s3_object" "Scripts" {
  for_each = fileset("/${path.module}/scripts/", "**")

  bucket = var.wp_bucket
  key    = "Scripts/${each.value}"
  source = "${path.module}/scripts/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag   = filemd5("${path.module}/scripts/${each.value}")

  acl = "public-read"
}