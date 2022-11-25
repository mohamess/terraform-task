variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "environment" {
  type = string
  default = "development"
}

variable "application" {
  type = string
  default = "terraform-task"
}

variable "bucket_name" {
  type = string
  default = "terraform-challenge-bo-state-bucket"
}