#  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group

resource "aws_iam_group" "bucket_full_access" {
  name = "${local.bucket_name}-full-access"

}

resource "aws_iam_group" "bucket_read_only" {
  name = "${local.bucket_name}-read-only"
}

# Notes:
# We would probably want a `developers` group and
# grant the correct privs to just that environment. A future activity.
