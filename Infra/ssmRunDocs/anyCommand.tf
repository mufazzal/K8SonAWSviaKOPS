resource "aws_ssm_document" "AnyCommand" {
  name            = "AnyCommand"
  document_format = "YAML"
  document_type   = "Command"

  content = <<DOC
---
schemaVersion: "2.2"
description: "Command Document Example JSON Template"
parameters:
  Command:
    type: "String"
    description: "Command to run"
    default: "pwd"
mainSteps:
- action: aws:runShellScript
  name: script_0
  inputs:
    runCommand:
    - "{{Command}}"
DOC
}
