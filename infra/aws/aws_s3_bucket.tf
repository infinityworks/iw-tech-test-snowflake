resource "aws_s3_bucket" "b" {
  bucket = "convex-s3-encrypted"
  acl    = "private"

  tags = {
    Name        = "convex-s3-encrypted"
    Environment = "Dev"
  }
}