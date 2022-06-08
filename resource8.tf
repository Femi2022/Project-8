# Configure the AWS Provider
provider "aws" {
  region = var.region

}

# AWS vpc
resource "aws_vpc" "P8-vpc" {
 cidr_block       = "10.0.0.0/16"
 instance_tenancy = "default"

 tags = {
   Name = "P8-vpc"
 }
}

# Create a Private Subnet 1
resource "aws_subnet" "private-tritek-1" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.private-subnet1-cidr

  tags = {
    Name = "private-tritek-1"
  }
}

# Create a Private Subnet 2
resource "aws_subnet" "private-tritek-2" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.private-subnet2-cidr

  tags = {
    Name = "private-tritek-2"
  }
}

# Create a Private Subnet 3
resource "aws_subnet" "private-tritek-3" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.private-subnet3-cidr

  tags = {
    Name = "private-tritek-3"
  }
}

# Create a Public Subnet 1
resource "aws_subnet" "public-tritek-1" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.public-subnet1-cidr
  availability_zone = var.zone_1

  tags = {
    Name = "public-tritek-1"
  }
}

# Create a Public Subnet 2
resource "aws_subnet" "public-tritek-2" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.public-subnet2-cidr
  availability_zone = var.zone_2

  tags = {
    Name = "public-tritek-2"
  }
}

# Create a Public Subnet 3
resource "aws_subnet" "public-tritek-3" {
  vpc_id     = aws_vpc.P8-vpc.id
  cidr_block = var.public-subnet3-cidr
  availability_zone = var.zone_3

  tags = {
    Name = "public-tritek-3"
  }
}

# Create a Public Route Table
resource "aws_route_table" "public-route-table-pro-8" {
  vpc_id = aws_vpc.P8-vpc.id

  route {
    cidr_block = var.public-route-table-cidr
    gateway_id = aws_internet_gateway.pro-8-igw.id
 }

  tags = {
    Name = "public-route-table-pro-8"
  }
}

# Create a Private Route Table
resource "aws_route_table" "private-route-table-pro-8" {
  vpc_id = aws_vpc.P8-vpc.id

  tags = {
    Name = "private-route-table-pro-8"
  }
}

# Create Route Table Association - Private Subnet 1
resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-tritek-1.id
  route_table_id = aws_route_table.private-route-table-pro-8.id
}

# Create Route Table Association - Private Subnet 2
resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-tritek-2.id
  route_table_id = aws_route_table.private-route-table-pro-8.id
}

# Create Route Table Association - Private Subnet 3
resource "aws_route_table_association" "private-subnet-3" {
  subnet_id      = aws_subnet.private-tritek-3.id
  route_table_id = aws_route_table.private-route-table-pro-8.id
}

# Create Route Table Association - Public Subnet 1
resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.public-tritek-1.id
  route_table_id = aws_route_table.public-route-table-pro-8.id
}

# Create Route Table Association - Public Subnet 2
resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.public-tritek-2.id
  route_table_id = aws_route_table.public-route-table-pro-8.id
}

# Create Route Table Association - Public Subnet 3
resource "aws_route_table_association" "public-subnet-3" {
  subnet_id      = aws_subnet.public-tritek-3.id
  route_table_id = aws_route_table.public-route-table-pro-8.id
}

# Create a Internet Gateway
resource "aws_internet_gateway" "pro-8-igw" {
  vpc_id = aws_vpc.P8-vpc.id

  tags = {
    Name = "pro-8-igw"
  }
}

# Create a Security Group 
resource "aws_security_group" "delta-sg" {
  name        = "delta-sg"
  description = "delta-sg inbound traffic"
  vpc_id      = aws_vpc.P8-vpc.id

  ingress {
    description      = "delta-sg from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "delta-sg"
  }
}

# Create Application Load Balancer
resource "aws_lb" "distrubution" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.delta-sg.id]
  subnets            = [
    aws_subnet.public-tritek-1.id,
    aws_subnet.public-tritek-2.id    
  ]

  tags = {
    Name = "distribution lb"
  }
}

# RDS Instance
resource "aws_db_instance" "db-pro-8" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  db_subnet_group_name =  aws_db_subnet_group.db-sub-group.name
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

# aws db subnet group
resource "aws_db_subnet_group" "db-sub-group" {
  name       = "db subnet group"

  subnet_ids = [
    aws_subnet.public-tritek-1.id,
    aws_subnet.public-tritek-2.id
  ]
   
  tags = {
    Name = "db subnetg"
 }
}
