terraform {
  required_version = "= v1.3.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    encrypt = true
    region = "eu-central-1"
    bucket = "terraform-challenge-bo-state-bucket"
    key = "terraform-state.tf"
  }
}

provider "aws" {
  region = var.aws_region
}