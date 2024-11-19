## Create subnet Group for DB Cluster
resource "aws_db_subnet_group" "wp-db-group" {
    name                 = "wp-db-group"
    subnet_ids = values(aws_subnet.nacent-db-subnet)[*].id

    tags = {
        Name = "wp-db-group"
    } 
}

# Fetch the secret value from Secrets Manager
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
}

## An Aurora MySQL DB Cluster for Data Persistence
resource "aws_rds_cluster" "wp-cluster" {
  cluster_identifier       = "wp-cluster"
  engine                   = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.11.2"
  availability_zones        = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  database_name             = "wpdb"
  #db_cluster_instance_class = "db.r6gd.xlarge"
  db_subnet_group_name      = aws_db_subnet_group.wp-db-group.name
  vpc_security_group_ids    = [aws_security_group.database-sg.id]
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

## Aurora DB Instances
resource "aws_rds_cluster_instance" "wp-cluster-instance" {
  count              = 3 
  identifier         = "wp-cluster-instance-${count.index + 1}" 
  cluster_identifier = aws_rds_cluster.wp-cluster.id
  instance_class     = "db.r5.large" 
  engine             = aws_rds_cluster.wp-cluster.engine
  engine_version     = aws_rds_cluster.wp-cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.wp-db-group.name
  availability_zone  = element(["eu-west-2a", "eu-west-2b", "eu-west-2c"], count.index)
  
  tags = {
    Name = "wp-cluster-instance-${count.index + 1}"
  }
}