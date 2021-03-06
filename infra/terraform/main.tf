provider "snowflake" {
  username = "..."
  account = "lla09293"
  region  = "us-east-1"
  password = "..."
  role = "ACCOUNTADMIN"
}

provider "aws" {
  region     = "us-west-1"
  access_key = "..."
  secret_key = "..."
}

terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
      version = "0.23.2"
    } 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}