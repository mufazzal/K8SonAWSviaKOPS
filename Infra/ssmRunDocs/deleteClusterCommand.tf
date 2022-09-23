resource "aws_ssm_document" "DeleteClusterCommand" {
  name            = "DeleteClusterCommand"
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
    - kops delete cluster --name=hn.k8shn.com --state s3://muf-k8s-kops-state-bucket --yes
    - sudo shutdown -h now
DOC
}
