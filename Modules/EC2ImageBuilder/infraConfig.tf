resource "aws_imagebuilder_infrastructure_configuration" "image_builder_infra" {
  instance_profile_name         = aws_iam_instance_profile.iamProfile.name
  instance_types                = ["t3.micro", "t3.medium"]
  key_pair                      = var.sshKeyName
  name                          = "${var.prefix}-${var.pipelineName}-Infra-Config"
  security_group_ids            = [aws_security_group.customSg.id]
  # sns_topic_arn                 = aws_sns_topic.example.arn
  subnet_id                     = var.subnet_id
  terminate_instance_on_failure = false

  logging {
    s3_logs {
      s3_bucket_name = var.logBucketName
      s3_key_prefix  = "${var.logBucketPrefix}/${var.pipelineName}/"
    }
  }

  tags = {
    ImageBuilderPipeLineName = var.pipelineName
  }
}
