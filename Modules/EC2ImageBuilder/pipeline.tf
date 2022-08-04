resource "aws_imagebuilder_image_pipeline" "imagebuilder_image_pipeline" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.imagebuilder_image_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.image_builder_infra.arn
  name                             = "${var.prefix}-${var.pipelineName}-image-builder-pipeline"
}
