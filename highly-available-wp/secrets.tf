# Create the secret to store database credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "rds-cluster-admin-password"
  description = "Master username and password for RDS cluster"

  tags = {
    Name = "rds-cluster-admin-password"
  }
}

# Store the initial secret value
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "P34167okw" 
  })
}
