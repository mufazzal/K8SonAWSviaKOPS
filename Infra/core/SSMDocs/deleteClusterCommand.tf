resource "aws_ssm_document" "DeleteClusterCommand" {
  name            = "${var.namePrefix}DeleteClusterCommand"
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
    timeoutSeconds: '1800'
    runCommand:
    - kops delete cluster --name=${var.kops_cluster_name} --state ${var.kops_state_bucket} --yes
    - sudo shutdown -h now
DOC
}
