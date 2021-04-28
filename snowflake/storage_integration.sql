  use role accountadmin;

  create storage integration convex_s3_encrypted_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::XXXXXXXXXX:role/snowflake_role' # removed my iam user and put XXX
  storage_allowed_locations = (
    's3://convex-s3-encrypted/transactions/', 
    's3://convex-s3-encrypted/customers/', 
    's3://convex-s3-encrypted/products/');