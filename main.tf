terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.37"
    }
  }
  backend "s3" {}
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
