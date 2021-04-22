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

variable "region" {
    type = "string"
    default = "eu-west-1"
}
