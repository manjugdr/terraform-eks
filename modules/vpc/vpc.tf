# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.public_subnet_additionaltags, {
    Name = "${var.project_name}-${var.environment}-pubsubnet${count.index + 1}"})  
  }


# Private Subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.private_subnet_additionaltags, {
    Name = "${var.project_name}-${var.environment}-prisubnet${count.index + 1}"})  
  }


# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# Route Tables
resource "aws_route_table" "public_route_table" {
  # 1 public RT is enough for all public subnets
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-pubrt"
  }
}

resource "aws_route_table" "private_route_table" {
  # How many ever private subnets available that many Private RT needs to be created
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway[0].id
    # Single NAT gateway
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-prirt${count.index + 1}"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  count = 1  # Single Elastic IP for the NAT Gateway
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-natgateway-eip"
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count             = 1  # Single NAT Gateway
  allocation_id     = aws_eip.nat_gateway_eip[0].id
  subnet_id         = aws_subnet.public_subnet[0].id  # Use the first public subnet for NAT Gateway

  tags = {
    Name = "${var.project_name}-${var.environment}-natgw"
  }
}
