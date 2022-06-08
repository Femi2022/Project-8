variable "vpc-cidr_block" {
  description = "vpc cidr_block" 
  default = "10.0.0.0/16"
}

variable "private-subnet1-cidr" {
  description = "public subnet 1 cidr_block"
  default = "10.0.0.0/24"
}

variable "private-subnet2-cidr" {
  description = "private subnet 2 cidr_block"
  default = "10.0.1.0/24"
}

variable "private-subnet3-cidr" {
  description = "private subnet 3 cidr_block"
  default = "10.0.2.0/24"
}

variable "public-subnet1-cidr" {
  description = "public subnet 1 cidr_block"
  default = "10.0.3.0/24"
}

variable "public-subnet2-cidr" {
  description = "public subnet 2 cidr_block"
  default = "10.0.4.0/24"
}

variable "public-subnet3-cidr" {
  description = "public subnet 3 cidr_block"
  default = "10.0.5.0/24"
}

variable "public-route-table-cidr" {
  description = "public route table cidr_block"
  default = "0.0.0.0/0"
}

variable "region" {
  description = "AWS region"
  default = "eu-west-2"
}

variable "username" {
  description = "db username"
  default = "pattern"
}

variable "password" {
  description = "db username password"
  default = "school123"
}

variable "instance_class" {
  description = "db instance_class"
  default = "db.t2.micro"
}

variable "zone_1" {
  description = "Pub_1_availability_zone"
  default = "eu-west-2a"
}

variable "zone_2" {
  description = "Pub_2_availability_zone"
  default = "eu-west-2b"
}

variable "zone_3" {
  description = "Pub_3_availability_zone"
  default = "eu-west-2c"
}