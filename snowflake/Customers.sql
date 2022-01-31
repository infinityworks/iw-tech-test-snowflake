--Snowflake
--Table Creation
CREATE DATABASE CONVEX_DB;
CREATE SCHEMA INPUT_DATA;

USE DATABASE CONVEX_DB;
USE SCHEMA INPUT_DATA;

--Creation of the stage based on Amazon S3 Bucket
--customers
CREATE OR REPLACE STAGE stage_customers
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/customers/';

--Check list of files to be staged
LIST @stage_customers;

--Copy info from stage to fina table in the right format
COPY INTO INPUT_DATA.CUSTOMERS_TBL 
FROM @stage_customers
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

--Checking data
SELECT * FROM INPUT_DATA.CUSTOMERS_TBL;

--Creation of the pipeline, with the option to automatically process the file as it is ready to load 
CREATE OR REPLACE PIPE CONVEX_DB.INPUT_DATA.PIPE_CUSTOMERS
AUTO_INGEST = TRUE as
COPY INTO INPUT_DATA.CUSTOMERS_TBL 
FROM @stage_customers
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);
