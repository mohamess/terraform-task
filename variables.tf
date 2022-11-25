variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets_availability_zones" {
  type = list(string)
}


variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "ec2_instances" {
  type        = map(map(string))
}

variable "ec2_bastion" {
  type        = map(string)
}

variable "root_password_length" {
  type = number
}