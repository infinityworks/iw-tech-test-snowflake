# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership

resource "aws_iam_group_membership" "full_access" {
  name  = "${local.bucket_name}-full-access"
  users = var.full_access_users
  group = aws_iam_group.bucket_full_access.name
}

resource "aws_iam_group_membership" "read_only" {
  name  = "${local.bucket_name}-read-only"
  users = var.read_only_users
  group = aws_iam_group.bucket_read_only.name
}
