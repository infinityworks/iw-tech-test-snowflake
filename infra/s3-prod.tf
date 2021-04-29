resource "aws_s3_bucket" "raw-data-prod" {
  bucket = "convex-raw-data-prod"
  acl    = "private"

  tags = {
    Terraform   = "true"
    Project     = "convex"
    Environment = "prod"
  }
}