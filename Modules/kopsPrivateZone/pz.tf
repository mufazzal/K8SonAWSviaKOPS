resource "aws_route53_zone" "privateK8sZone" {
  name = var.zoneName 

  vpc {
    vpc_id = var.vpc_id
  }
}