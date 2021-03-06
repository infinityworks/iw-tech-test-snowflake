resource "aws_s3_bucket" "data_load" {
  bucket = "btourani-test-convex"
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  versioning {
      enabled = true
    }
}