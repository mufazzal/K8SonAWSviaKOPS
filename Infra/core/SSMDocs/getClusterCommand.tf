resource "aws_ssm_document" "GetClusterCommand" {
  name            = "${var.namePrefix}GetClusterCommand"
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
    timeoutSeconds: '60'
    runCommand:
    - kops get cluster --state ${var.kops_state_bucket}
DOC
}
