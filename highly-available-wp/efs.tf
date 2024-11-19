resource "aws_efs_file_system" "nacent-efs" {
   creation_token = "efs"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = true
   kms_key_id = aws_kms_key.efs_kms_key.arn
   
 tags = {
     Name = "nacent-efs"
   }
 }

resource "aws_efs_mount_target" "efs-mt" {
   file_system_id  = aws_efs_file_system.nacent-efs.id
   for_each = aws_subnet.nacent-private-subnet
   subnet_id = each.value.id
   security_groups = [aws_security_group.efs-sg.id]

 }

