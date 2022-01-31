USE DATABASE CONVEX_DB;
USE SCHEMA INPUT_DATA;

--Creation of the stage based on Amazon S3 Bucket
CREATE OR REPLACE STAGE stage_transactions 
FILE_FORMAT = json_format
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/transactions/transactions';

--Check list of files to be staged
list @stage_transactions;

--Copy info from stage to final table in the right format
COPY INTO "CONVEX_DB"."INPUT_DATA"."TRANSACTIONS_BASE_TBL"
FROM @stage_transactions;

--Checking data
SELECT * 
FROM  "CONVEX_DB"."INPUT_DATA"."TRANSACTIONS_BASE_TBL";

--Creation of the pipeline, with the option to automatically process the file as it is ready to load 
CREATE OR REPLACE PIPE CONVEX_DB.INPUT_DATA.TRANSACTIONS_PIPE 
AUTO_INGEST = true as
COPY INTO INPUT_DATA.TRANSACTIONS_BASE_TBL 
FROM @stage_transactions;
