resource "aws_launch_template" "launchTemplate" {
  name          = "${var.namePrefix}-${var.launchTemplateName}"
  image_id      = var.amiId
  instance_type = var.instanceType
  key_name      = var.sshKeyName
  iam_instance_profile {
    arn = aws_iam_instance_profile.iamProfile.arn
  }
  instance_market_options {
    market_type = "spot"
  }
  network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    security_groups = [aws_security_group.customSg.id]
    delete_on_termination = true
    subnet_id = var.subnet_id 
  }
#  user_data = filebase64(var.userDataFilePath)

  update_default_version = var.update_launch_template_default_version
  user_data = base64encode(templatefile(var.userDataFilePath, var.userDataParamMap))
}
