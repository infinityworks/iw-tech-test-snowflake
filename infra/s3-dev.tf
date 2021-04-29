resource "aws_s3_bucket" "raw-data-dev" {
  bucket = "convex-raw-data-dev"
  acl    = "private"

  tags = {
    Terraform   = "true"
    Project     = "convex"
    Environment = "dev"
  }
}

