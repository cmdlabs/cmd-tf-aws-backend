terraform {
  backend "s3" {
    bucket         = "cmdlabtf-terraform-backend"
    key            = "module-cmd-tf-aws-backend-aws3"
    region         = "ap-southeast-2"
    profile        = "cmdlabtf-tfbackend"
    dynamodb_table = "cmdlabtf-terraform-lock"
  }

  required_providers {
    aws = {
      version = "3.51.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-2"
  profile = "cmdlabtf-master"
}