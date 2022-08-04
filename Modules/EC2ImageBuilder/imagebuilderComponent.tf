resource "aws_imagebuilder_component" "imagebuilder_component" {
  data = file(var.componentFileName) #yamlencode(file(var.componentFileName))
  name     = "${var.prefix}-${var.pipelineName}-imagebuilder-component"
  platform = "Linux"
  version  = var.imb_version
}
