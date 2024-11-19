# Terraform Block
terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
      
    }
  }
  
  backend "s3" {
    bucket = "nacent-state-bucket-040724"
    key    = "wordpress/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt = true
  }
  
}
     
  
 
# Provider Block
provider "aws" {
  region = var.aws_region
  
}

/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/

