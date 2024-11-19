
# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

data "aws_caller_identity" "current" {}
locals {
  principal_root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  principal_logs_arn = "logs.${var.aws_region}.amazonaws.com"
  slow_log_arn       = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${var.replication_group_id}/slow-log"
  engine_log_arn     = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${var.replication_group_id}/engine-log"
}