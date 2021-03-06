-- storage integration is an object associate with
-- the account so we need to assume "ACCOUNTADMIN" role
-- to be eble to create it

use role accountadmin;

create storage integration convex_s3_integration
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::037778210167:role/snowflake_access_to_convex_bucket'
storage_allowed_locations = ('s3://babak4-test-convex/data/');

desc integration s3_int;

-- Stage object can be create after this script
-- is executed and the associated trust policy defined
-- the IAM role is updated with the values of
-- "STORAGE_AWS_IAM_USER_ARN" and "STORAGE_AWS_EXTERNAL_ID"