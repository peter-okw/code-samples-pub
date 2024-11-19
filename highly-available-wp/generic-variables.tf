# Input Variables

# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "eu-west-2"  
}

variable "replication_group_id" {
  description = "Redis Replication Groupe Name"
  type = string
  default = "wp-replication-group"  
}



