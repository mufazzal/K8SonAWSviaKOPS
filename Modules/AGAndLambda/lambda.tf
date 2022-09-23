resource "aws_lambda_function" "lambda" {
  function_name = "${var.prefix}-${var.lambdaName}"

  s3_bucket = var.bucket_id
  s3_key    = "${var.bucketPartitionForLambdaTempSourceCode}${var.prefix}${var.lambdaName}-source-code.zip"

  runtime = "nodejs14.x"
  handler = var.handler #"createCluster/src/index.createCluster"

  source_code_hash = data.archive_file.lambda_source_code_local.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = var.envVariables
  }

}