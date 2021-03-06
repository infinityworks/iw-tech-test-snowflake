-- The stage object should only be created when 
-- the storage integration is in place and the 
-- associated changes are done to the trust policy
-- of the IAM role.

use role sysadmin;

create stage staging.convex_data
storage_integration = s3_int
url = 's3://{bucket name}/data/';
