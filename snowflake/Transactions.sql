USE DATABASE CONVEX_DB;
USE SCHEMA INPUT_DATA;

--Creation of the stage based on Amazon S3 Bucket
CREATE OR REPLACE TABLE stage stage_transactions 
FILE_FORMAT = json_format
URL = 's3://s3-bucket-convex-test/input_data/transactions/transactions'
CREDENTIALS=(AWS_KEY_ID='AKIA3AACTOFR6ACOZYHN' AWS_SECRET_KEY='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');

--Check list of files to be staged
list @stage_transactions;

--Copy info from stage to final table in the right format
COPY INTO "CONVEX_DB"."INPUT_DATA"."TRANSACTIONS_BASE_TBL"
FROM @stage_transactions

--Checking data
SELECT * 
FROM  "CONVEX_DB"."INPUT_DATA"."TRANSACTIONS_BASE_TBL";

--Creation of the pipeline, with the option to automatically process the file as it is ready to load 
CREATE OR REPLACE PIPE CONVEX_DB.INPUT_DATA.TRANSACTIONS_PIPE 
AUTO_INGEST = true as
COPY INTO INPUT_DATA.TRANSACTIONS_BASE_TBL 
FROM @stage_transactions;
