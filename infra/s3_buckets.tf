# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

locals {
  bucket_name = "${var.aws_bucket_prefix}-${random_integer.seed.result}"
}

# TODO: use KMS to encrypt bucket etc.
resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  force_destroy = false

  versioning {
    enabled = true
  }

  tags = var.default_tags
}

# TODO - did not work as expected - ideally block ability to make objects public.
# can mitigate with iam set-up..
resource "aws_s3_bucket_public_access_block" "s3_no_public_access" {
  bucket              = aws_s3_bucket.state_bucket.id
  block_public_acls   = true
  block_public_policy = true
}


output "state_bucket" {
  value = aws_s3_bucket.state_bucket.id
}
