/*
    I used this script to set-up the requirements on the snowflake end.
    I could have used the chanzuckerberg snowflake provider,
    which I have used in the past to set-up alot of this stuff, but
    for time I opted for SQL.
 */


USE ROLE SYSADMIN;
CREATE DATABASE RAW;
CREATE DATABASE ANALYTICS;

USE ROLE SECURITYADMIN;

-- LOADER
CREATE ROLE LOADER;
GRANT ROLE LOADER TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE RAW TO ROLE LOADER;
GRANT ALL ON DATABASE RAW TO ROLE LOADER;

-- TRANFORMER
CREATE ROLE TRANSFORMER;
GRANT ROLE TRANSFORMER TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE RAW TO ROLE TRANSFORMER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW TO ROLE TRANSFORMER;
GRANT SELECT ON ALL TABLES IN DATABASE RAW TO ROLE TRANSFORMER;
GRANT SELECT ON ALL VIEWS IN DATABASE RAW TO ROLE TRANSFORMER;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW TO ROLE TRANSFOMER;
GRANT SELECT ON FUTURE TABLES IN DATABASE RAW TO ROLE TRANSFOMER;
GRANT SELECT ON FUTURE VIEWS IN DATABASE RAW TO ROLE TRANSFOMER;


-- TRANSFORMER should in theory be the only role writing to this DB
-- hence we will skip future grants.
GRANT ALL DATABASE ANALYTICS TO ROLE TRANSFORMER;
-- use the default warehouse for now, but should be using warehouses
-- specific to the use case. (TODO - create usage based warehouses)
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE LOADER;

-- creating the tables as LOADER role so that it has access to any
-- table stages.. which is another way of doing this without s3.

USE ROLE LOADER;
CREATE SCHEMA RAW.INFINITY_WORKS;

CREATE OR REPLACE TABLE CUSTOMERS(
  customer_id string,
  loyalty_score number
);

CREATE OR REPLACE TABLE PRODUCTS(
  product_id string,
  product_description string,
  product_category string
);

CREATE OR REPLACE TABLE TRANSACTIONS(
  transaction_detail variant
);

-- Setup a storage integration, which is what snowflake recommends
-- as credentials do not have to be supplied when using the external stage.
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<AWS_ACCOUNT_ID_GOES_HERE>:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://iw-demo-data/');

-- update aws trust entity with the values STORAGE_AWS_IAM_USER_ARN, STORAGE_AWS_EXTERNAL_ID
DESC INTEGRATION s3_integration;

-- allow LOADER, the primary user of the integration to use it.
USE ROLE SECURITYADMIN;
GRANT USAGE ON INTEGRATION s3_integration to role LOADER;


-- Now we can create stages and start loading data.
USE ROLE LOADER;
CREATE OR REPLACE STAGE raw.infinity_works.ext__base_data
  storage_integration = s3_integration
  url = 's3://iw-demo-data/';

CREATE OR REPLACE STAGE raw.infinity_works.ext__transactions -- transactions partitioned by date.
  storage_integration = s3_integration
  url = 's3://iw-demo-data/transactions/';

USE WAREHOUSE COMPUTE_WH;
USE DATABASE RAW;
USE SCHEMA INFINITY_WORKS;

COPY INTO CUSTOMERS
  FROM @RAW.INFINITY_WORKS.EXT__BASE_DATA
  PATTERN='CUSTOMERS.CSV'
  FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

COPY INTO PRODUCTS
  FROM @RAW.INFINITY_WORKS.EXT__BASE_DATA
  PATTERN='PRODUCTS.CSV'
  FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

COPY INTO TRANSACTIONS
  FROM @RAW.INFINITY_WORKS.EXT__TRANSACTIONS
  FILE_FORMAT = (TYPE = 'JSON');

/*
    Data is now loaded... time to use dbt to model it.
*/