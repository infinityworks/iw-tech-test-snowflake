resource "aws_iam_role" "list_s3" {
  name = "convex-s3-snowflake-list-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : snowflake_storage_integration.convex_integration.storage_aws_iam_user_arn },
        Condition = {"StringEquals": {"sts:ExternalId": snowflake_storage_integration.convex_integration.storage_aws_external_id}}
#        Principal = { "AWS" : "arn:aws:iam::679796093283:user/feqq-s-v2sw5398" },
#        Condition = {"StringEquals": {"sts:ExternalId": "LLA09293_SFCRole=2_FLMHFabPm1wcxR+je0JYczvcwyA="}}
    }]
  })
}

resource "aws_iam_policy" "s3_list_data" {
  name        = "s3_list_data"
  description = "allows listing all s3 buckets"
  policy      = file("s3_role_permission_policy.json")
}

resource "aws_iam_policy_attachment" "s3_list_all" {
  name       = "list s3 buckets policy to role"
  roles      = [aws_iam_role.list_s3.name]
  policy_arn = aws_iam_policy.s3_list_data.arn
}