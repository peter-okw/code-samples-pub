## Create Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = values(aws_subnet.nacent-db-subnet)[*].id
}

## Create Elasticache for REDIS Replication Group
resource "aws_elasticache_replication_group" "wp-replication-group" {
  automatic_failover_enabled = true
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  replication_group_id       = var.replication_group_id
  description                = "ElastiCache cluster for WordPress"
  node_type                  = "cache.t2.medium"
  parameter_group_name       = "default.redis7.cluster.on"
  port                       = 6379
  multi_az_enabled           = true
  num_node_groups            = 3
  replicas_per_node_group    = 2
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.encryption_rest.id
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.auth.secret_string
  security_group_ids         = [aws_security_group.redis-sg.id]
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.slow_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.engine_log.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
  lifecycle {
    ignore_changes = [kms_key_id]
  }
  apply_immediately = true
}
  
