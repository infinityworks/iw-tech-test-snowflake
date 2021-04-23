# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  backend "s3" {
    key = "networking/dev/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.37.0"
    }
  }
}

provider "aws" {
  region = var.region
}
