resource "aws_imagebuilder_image_recipe" "imagebuilder_image_recipe" {

  depends_on = [
    aws_imagebuilder_component.imagebuilder_component
  ]

  component {
    component_arn = aws_imagebuilder_component.imagebuilder_component.arn
    # parameter {
    #   name  = "Parameter1"
    #   value = "Value1"
    # }

    # parameter {
    #   name  = "Parameter2"
    #   value = "Value2"
    # }
  }

  name         = "${var.prefix}-${var.pipelineName}-image-recipe"
  parent_image = "ami-09d56f8956ab235b3"
  #parent_image = "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x"
  version      = var.imb_version
}
