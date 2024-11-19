## Create IAM Policy for KMS to Permit Encryption
/*
resource "aws_kms_key_policy" "encryption_rest_policy" {
  key_id = aws_kms_key.encryption_rest.id
  policy = jsonencode({
    Id = "encryption-rest"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "${local.principal_root_arn}"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
      {
        Effect   = "Allow",
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}
*/

resource "aws_kms_key_policy" "encryption_rest_policy" {
  key_id = aws_kms_key.encryption_rest.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "Enable IAM User Permissions"
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs access"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}