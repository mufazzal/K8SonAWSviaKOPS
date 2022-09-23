data "archive_file" "lambda_source_code_local" {
  type = "zip"

  source_dir  = var.sourceCodeDir # "${path.module}/hello-world"
  output_path = "${var.tmpDirectory}/${var.prefix}${var.lambdaName}-source-code.zip"
}

resource "aws_s3_object" "lambda_source_code_s3" {
  # bucket = aws_s3_bucket.lambda_bucket.id
  bucket = var.bucket_id

  key    = "${var.bucketPartitionForLambdaTempSourceCode}${var.prefix}${var.lambdaName}-source-code.zip"
  source = data.archive_file.lambda_source_code_local.output_path

  etag = filemd5(data.archive_file.lambda_source_code_local.output_path)
}