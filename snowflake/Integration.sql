CREATE STORAGE INTEGRATION bottega_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::600148844715:role/snowflake_access_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://bottega-snowflake/');

create schema demo_db.staging;

Use schema DEMO_DB.staging;

create stage s3_stage_json
  storage_integration = bottega_integration
  url = 's3://bottega-snowflake/'
  FILE_FORMAT = (type = JSON);
  
create stage s3_stage_csv
  storage_integration = bottega_integration
  url = 's3://bottega-snowflake/'
  FILE_FORMAT = (type = CSV SKIP_HEADER = 1);
