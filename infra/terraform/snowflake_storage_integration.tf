resource snowflake_storage_integration "convex_integration" {
  name    = "si_convex"
  comment = "A storage integration for Convex' bucket"
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_allowed_locations = ["s3://${aws_s3_bucket.data_load.bucket}/data/"]
  
  storage_provider         = "S3"
  storage_aws_role_arn     = aws_iam_role.list_s3.arn

}