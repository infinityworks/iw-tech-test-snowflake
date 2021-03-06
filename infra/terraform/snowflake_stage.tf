resource "snowflake_stage" "convex_stage" {
  name        = "CONVEX_DATA"
  url         = "s3://${aws_s3_bucket.data_load.id}/data/"
  database    = snowflake_database.convex_db.name
  schema      = "STAGING"
  credentials = "AWS_KEY_ID='${aws_iam_access_key.snowflake.id}' AWS_SECRET_KEY='${aws_iam_access_key.snowflake.secret}'"
  depends_on = [
    snowflake_schema.schemas
  ]  
}
