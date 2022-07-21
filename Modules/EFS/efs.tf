resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "false"
  #availability_zone_name = "us-east-1a"
  tags = {
      Name = "efs"
    }
 }
