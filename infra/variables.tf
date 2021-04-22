variable "aws_bucket_prefix" {
  type = string
  default = "infinityworks-demo"
}

variable "aws_dynamodb_table" {
  type = string
  default = "infinityworks-demo-tfstatelock"
}

# Best Practice - autotag resources
variable "default_tags" {
    type = map
    default = {
        key: "value",
        Name: "Value",
        managed_by_terraform: true,
        department: "Data Engineering"
  }
}

# Depending how you opt to provision resources, this can be very useful.
# different aws accounts/zones or shared?
variable "environment" {
  type = string
  default = "dev"
}

variable "full_access_users" {
  type = list(string)
}

variable "read_only_users" {
  type = list(string)
}

variable "region" {
    type = string
    default = "eu-west-1"
}
