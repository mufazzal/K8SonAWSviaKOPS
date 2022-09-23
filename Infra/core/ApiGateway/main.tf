module "APIGateway" {

  source = "../../../Modules/APIGateway"
  apiGatewayName = var.apiGatewayName
  stageName = var.stageName
}