## Create VPC
resource "aws_vpc" "nacent-vpc" {
  cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" 
    enable_dns_hostnames = "true"
    instance_tenancy = "default"   
    tags = {
        Name = "nacent-vpc" 
    }
}

## Fetch the Availability Zones
data "aws_availability_zones" "available" {}



## Create Internet Gatway
resource "aws_internet_gateway" "nacent-ig" {
    vpc_id = "${aws_vpc.nacent-vpc.id}"
    tags = {
        Name = "nacent-ig"
    }
}

## Create Elastic IPs for each NAT Gateway
resource "aws_eip" "nacent-NAT-eip" {
  for_each = aws_subnet.nacent-public-subnet

      
  tags = {
    Name = "nacent-NAT-eip-${each.key}"
  }
}

## Create Public Subnets in different Availability Zones (already created in previous step)
resource "aws_subnet" "nacent-public-subnet" {
  for_each = toset(var.availability_zones)
  
  vpc_id            = aws_vpc.nacent-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.nacent-vpc.cidr_block, 8, index(var.availability_zones, each.value))
  availability_zone = each.value
  map_public_ip_on_launch = true  

  tags = {
    Name = each.key
  }
}

## Create NAT Gateways for each Public Subnet
resource "aws_nat_gateway" "nacent-NAT-GW" {
  for_each = aws_subnet.nacent-public-subnet
  subnet_id = each.value.id
  allocation_id = aws_eip.nacent-NAT-eip[each.key].id
  connectivity_type = "public"

  tags = {
    Name = "nacent-NAT-GW-${each.key}"
  }
}

## Create Route Table for Public Subnets
resource "aws_route_table" "nacent-public-rt" {
  for_each = aws_subnet.nacent-public-subnet
  vpc_id = aws_vpc.nacent-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nacent-ig.id
  }

  tags = {
    Name = "nacent-public-rt-${each.key}"
  }
}

## Associate Route Table with Public Subnets
resource "aws_route_table_association" "nacent-public_route_table_assoc" {
  for_each = aws_subnet.nacent-public-subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.nacent-public-rt[each.key].id
}
  

## Create Private Subnets in the same Availability Zones
resource "aws_subnet" "nacent-private-subnet" {
  for_each = toset(var.availability_zones)
  vpc_id            = aws_vpc.nacent-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.nacent-vpc.cidr_block, 8, length(var.availability_zones) + index(var.availability_zones, each.value))
  
  availability_zone = each.value

  tags = {
    Name = "nacent-private-subnet-${each.key}"
  }
}

## Create Route Table for Private Subnets
resource "aws_route_table" "nacent-private-rt" {
  for_each = aws_subnet.nacent-private-subnet
  vpc_id = aws_vpc.nacent-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nacent-NAT-GW[each.key].id
  }

  tags = {
    Name = "nacent-private-rt-${each.key}"
  }
}

## Associate Route Table with Private Subnets
resource "aws_route_table_association" "nacent-private_route_table_assoc" {
  for_each = aws_subnet.nacent-private-subnet
  
  subnet_id = each.value.id
  route_table_id = aws_route_table.nacent-private-rt[each.key].id
}

## Create Database Subnets in the same Availability Zones
resource "aws_subnet" "nacent-db-subnet" {
  for_each = toset(var.availability_zones)
   
  vpc_id            = aws_vpc.nacent-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.nacent-vpc.cidr_block, 8, 2 * length(var.availability_zones) + index(var.availability_zones, each.value)) 
  availability_zone = each.value

  tags = {
    Name = "nacent-db-subnet-${each.key}"
  }
}
