# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

locals {
  bucket_name = "${var.aws_bucket_prefix}-${random_integer.seed.result}"
}

# TODO: use KMS to encrypt bucket etc.
resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  # as this is a demo, for sake of clean-up this is true
  # - should make env aware so that it is always false on prod.
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = var.default_tags
}
