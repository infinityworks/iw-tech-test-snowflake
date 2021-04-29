
SETUP_USER_AND_ROLE = ["USE ROLE SYSADMIN;",
"create WAREHOUSE IF NOT EXISTS STAGING_WH WAREHOUSE_SIZE='X-SMALL' INITIALLY_SUSPENDED=TRUE;",
"create DATABASE IF NOT EXISTS {DB};",
"CREATE SCHEMA IF NOT EXISTS {DB}.STAGING;",
"CREATE SCHEMA IF NOT EXISTS {DB}.PERSIST ;",
"CREATE SCHEMA IF NOT EXISTS {DB}.ANALYTICS;",
]

SETUP_DB_OBJECTS = [
"""create table if not exists {DB}.STAGING.TRANSACTIONS(
            PAYLOAD VARIANT,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));""",
            
"""create table if not exists {DB}.STAGING.CUSTOMERS(
            customer_id VARIANT,
            loyalty_score VARIANT,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));""",

"""create table if not exists {DB}.STAGING.PRODUCTS(
            product_id VARIANT,
            product_description VARIANT,
            product_category VARIANT,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));""",

"""
create table if not exists {DB}.PERSIST.TRANSACTIONS(
            customer_id string,
            price number,
            product_id string,
            date_of_purchase datetime,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));
""",

            
"""CREATE or replace STAGE {DB}.STAGING.TRANSACTIONS_JSON
  url='s3://{BUCKET}/TRANSACTIONS'
  COMMENT = 'Stage for transactions data from external S3 location in JSON format'
  credentials = (AWS_KEY_ID = '{AWS_KEY_ID}' AWS_SECRET_KEY = '{AWS_SECRET_KEY}')
  file_format = (type = 'json', compression = gzip)
  COPY_OPTIONS = (ON_ERROR = SKIP_FILE);""",

"""CREATE or replace STAGE {DB}.STAGING.CUSTOMERS_CSV
url='s3://{BUCKET}/CUSTOMERS'
COMMENT = 'Stage for customers data from external S3 location in CSV format'
credentials = (AWS_KEY_ID = '{AWS_KEY_ID}' AWS_SECRET_KEY = '{AWS_SECRET_KEY}')
file_format = (type = 'csv', empty_field_as_null = true, SKIP_HEADER = 1)
COPY_OPTIONS = (ON_ERROR = SKIP_FILE);""",

"""CREATE or replace STAGE {DB}.STAGING.PRODUCTS_CSV
url='s3://{BUCKET}/PRODUCTS'
COMMENT = 'Stage for products data from external S3 location in CSV format'
credentials = (AWS_KEY_ID = '{AWS_KEY_ID}' AWS_SECRET_KEY = '{AWS_SECRET_KEY}')
file_format = (type = 'csv', empty_field_as_null = true, SKIP_HEADER = 1)
COPY_OPTIONS = (ON_ERROR = SKIP_FILE);""",

"""
create table if not exists {DB}.PERSIST.CUSTOMERS(
            customer_id string,
            loyalty_score integer,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));  
""",

"""
create table if not exists {DB}.PERSIST.PRODUCTS(
            product_id string,
            product_description string,
            product_category string,
            FILE_KEY VARCHAR,
            INSERTED_TIMESTAMP TIMESTAMP_TZ(9));
"""
]


