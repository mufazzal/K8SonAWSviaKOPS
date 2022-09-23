resource "aws_ssm_document" "InstallCWAgent" {
  name            = var.ssm_doc_installCWAgent
  document_format = "YAML"
  document_type   = "Command"

  content = <<DOC

---
schemaVersion: '2.2'
description: aws:runShellScript
mainSteps:
- action: aws:runShellScript
  name: script_0
  inputs:
    timeoutSeconds: '300'
    runCommand:
    - curl -o /root/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
    - dpkg -i -E /root/amazon-cloudwatch-agent.deb
    - sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:${var.CWConfigSSMParam} -s
DOC
}
