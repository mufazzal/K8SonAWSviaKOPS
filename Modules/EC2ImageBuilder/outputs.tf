output "img_builder_infra_arn" {
  description = "ID of the VPC"
  value       = aws_imagebuilder_infrastructure_configuration.image_builder_infra.arn
}

output "img_builder_infra_id" {
  description = "ID of the VPC"
  value       = aws_imagebuilder_infrastructure_configuration.image_builder_infra.id
}

output "img_builder_component_arn" {
  description = "ID of the VPC"
  value       = aws_imagebuilder_component.imagebuilder_component.arn
}

output "img_builder_recipe_arn" {
  description = "ID of the VPC"
  value       = aws_imagebuilder_image_recipe.imagebuilder_image_recipe.arn
}

output "img_builder_pipeline_arn" {
  description = "ID of the VPC"
  value       = aws_imagebuilder_image_pipeline.imagebuilder_image_pipeline.arn
}