## Create KMS Key for EFS Data Encryption
resource "aws_kms_key" "encryption_secret" {
  enable_key_rotation     = true
  description             = "Key to encrypt secret"
  deletion_window_in_days = 7
}  

resource "aws_kms_alias" "encryption_secret" {
  name          = "alias/wp-data-in-transit"
  target_key_id = aws_kms_key.encryption_secret.key_id
}

resource "aws_kms_key" "encryption_rest" {
  enable_key_rotation     = true
  description             = "Key to encrypt cache at rest."
  deletion_window_in_days = 7
  
}

resource "aws_kms_alias" "encryption_rest" {
  name          = "alias/catche-data-at-rest"
  target_key_id = aws_kms_key.encryption_rest.key_id
}

 ##Create a KMS Key for EFS Encryption
 resource "aws_kms_key" "efs_kms_key" {
  description             = "KMS key for encrypting EFS at rest"
  deletion_window_in_days = 7

 tags = {
    Name = "efs_kms_key"
  } 
}