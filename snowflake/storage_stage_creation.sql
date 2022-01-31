USE ROLE ACCOUNTADMIN;
USE database CONVEX_DB;
USE SCHEMA INPUT_DATA;

--Creation of a snowflake storage integration
CREATE OR REPLACE STORAGE integration storage_convex
TYPE = external_stage
STORAGE_PROVIDER = s3
ENABLED = true
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::755919712611:role/convex_role' 
STORAGE_ALLOWED_LOCATIONS = (
    's3://s3-bucket-convex-test/input_data/customers/', 
    's3://s3-bucket-convex-test/input_data/products/', 
    's3://s3-bucket-convex-test/input_data/transactions/transactions'
    )
;

--Getting info from snowflake to link with aws role
desc integration storage_convex;


----------------------------
--Create stages
----------------------------
--customers
CREATE OR REPLACE STAGE stage_customers
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/customers/';
--products
CREATE OR REPLACE STAGE stage_products
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/products/';
--transactions
CREATE OR REPLACE STAGE stage_transactions 
FILE_FORMAT = json_format
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/transactions/transactions';

--Checking files from stage
LIST @stage_customers;
LIST @stage_products;
LIST @stage_transactions;
