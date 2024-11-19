
## Create Security Group for AutoScsaled Instances
resource "aws_security_group" "instances-sg" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
    name = "instances-sg"
    egress = [
        {
        description = "Traffic Allowed Out of VPC"    
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        } 
    ] 
    ingress = [
        {
            description = "HTTPS into VPC"
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [ aws_security_group.nacent-alb-sg.id, aws_security_group.wp-instances-web-sg.id ]
            self = false    
        },
        {
            description = "HTTP into VPC"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [aws_security_group.nacent-alb-sg.id, aws_security_group.wp-instances-web-sg.id]
            self = false    
        },
        {
            description = "SSH into VPC"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = [aws_security_group.bastion-sg.id]
            self = false    
        },
        
     ]
}

## Security Group for ALB
resource "aws_security_group" "nacent-alb-sg" {
    vpc_id = aws_vpc.nacent-vpc.id
    name = "nacent-alb-sg"
   
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Create Security Group for Bastion Host
resource "aws_security_group" "bastion-sg" {
     vpc_id = aws_vpc.nacent-vpc.id
     name = "bastion-sg"
     egress = [
        {
        description = "Traffic Allowed Out of VPC"    
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        }
    ]
    ingress = [
        {
        description = "Allow Admin Access to Bastion Host Over SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
        } 
    ]         
}
## Create security group for EFS 
resource "aws_security_group" "efs-sg" {
  vpc_id = aws_vpc.nacent-vpc.id
  name = "efs-sg"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow within VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Create Security Group for RDS
resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  vpc_id      = aws_vpc.nacent-vpc.id
  description = "Security group for Aurora MySQL RDS"

  # Allow Application server to access Aurora MySQL RDS (port 3306)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    security_groups = [aws_security_group.instances-sg.id, aws_security_group.bastion-sg.id ]
    self = false
  }

  # Add egress rule allowing all outbound traffic from RDS
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Creat Security Group for Elasticache for REDIS
resource "aws_security_group" "redis-sg" {
  vpc_id = aws_vpc.nacent-vpc.id
  name = "redis-sg"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow access from VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Temporary Security Group to Grant Web Access to Sample WP Instance
resource "aws_security_group" "wp-instances-web-sg" {
  vpc_id = "${aws_vpc.nacent-vpc.id}"
  name = "wp-instances-web-sg"
    egress = [
        {
        description = "Traffic Allowed Out of VPC"    
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
        } 
    ] 
    ingress = [
        {
            description = "HTTPS into VPC"
            from_port = 443
            to_port = 443
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false    
        },
        {
            description = "HTTP into VPC"
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false    
        }
    ]
}