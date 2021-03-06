resource "aws_iam_access_key" "snowflake" {
  user    = aws_iam_user.snowflake.name
}

resource "aws_iam_user" "snowflake" {
  name = "snowflake-test"
}

resource "aws_iam_user_policy" "snowflake_s3" {
  name = "test"
  user = aws_iam_user.snowflake.name

  policy = file("s3_user_permission_policy.json")
}
