resource "aws_resourcegroups_group" "AllK8sNodes" {
  name = var.allResources

  resource_query {
    query = <<JSON
          {
            "ResourceTypeFilters": [
              "AWS::EC2::Instance"
            ],
            "TagFilters": [
              {
                "Key": "${var.TAG_Stack}",
                "Values": ["${var.VAL_K8sHN}"]
              }
            ]
          }
        JSON
  }
}
