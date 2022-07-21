 resource "aws_efs_mount_target" "efs_mt" {
    count = length(var.mtHostingSubnets)
    file_system_id  = aws_efs_file_system.efs.id
    subnet_id = var.mtHostingSubnets[count.index]
    security_groups = [aws_security_group.customSg.id]
    # Not supported
    # tags = {
    #   Name = "MT-${var.mtHostingSubnets[count.index]}-${var.creation_token}"
    # }   
 }