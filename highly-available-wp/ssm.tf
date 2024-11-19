## Create SSM Parameter Store for Elasticache for REDIS
resource "aws_ssm_parameter" "elasticache_ep" {
  name   = "/${aws_elasticache_replication_group.wp-replication-group.replication_group_id}/endpoint"
  type   = "SecureString"
  key_id = aws_kms_key.encryption_rest.id
  value  = aws_elasticache_replication_group.wp-replication-group.configuration_endpoint_address
}

resource "aws_ssm_parameter" "elasticache_port" {
  name   = "/${aws_elasticache_replication_group.wp-replication-group.replication_group_id}/port"
  type   = "SecureString"
  key_id = aws_kms_key.encryption_rest.id
  value  = aws_elasticache_replication_group.wp-replication-group.port
}

resource "aws_secretsmanager_secret" "elasticache_auth" {
  name                    = "wp-elasticache-auth"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.encryption_secret.id
} 

resource "aws_secretsmanager_secret_version" "auth" {
  secret_id     = aws_secretsmanager_secret.elasticache_auth.id
  secret_string = random_password.auth.result
}

resource "random_password" "auth" {
  length           = 128
  special          = true
  override_special = "!&#$^<>-"
}