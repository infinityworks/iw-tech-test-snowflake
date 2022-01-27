Create database ConvexTest;

CREATE OR REPLACE FILE FORMAT jsonformat
type = 'JSON'
strip_outer_array = true;

CREATE OR REPLACE stage stage_convex_customers url='s3://convextest/input_data/starter/customers/'
credentials=(aws_key_id='AKIAQ4D2QSCHATXELOTP' aws_secret_key='OQCQpXO49nNn0OLt8vQD01PNL+rH3u2IJD49xub+');

CREATE OR REPLACE stage stage_convex_products url='s3://convextest/input_data/starter/products/'
credentials=(aws_key_id='AKIAQ4D2QSCHATXELOTP' aws_secret_key='OQCQpXO49nNn0OLt8vQD01PNL+rH3u2IJD49xub+');

CREATE OR REPLACE stage stage_convex_transactions file_format = jsonformat url='s3://convextest/input_data/starter/transactions/'
credentials=(aws_key_id='AKIAQ4D2QSCHATXELOTP' aws_secret_key='OQCQpXO49nNn0OLt8vQD01PNL+rH3u2IJD49xub+');

CREATE OR REPLACE TABLE SRC_SCHEMA.CUSTOMERS
(
    CUSTOMER_ID VARCHAR NOT NULL,
    LOYALTY_SCORE INT NOT NULL
);

CREATE OR REPLACE TABLE SRC_SCHEMA.PRODUCTS
(
    PRODUCT_ID VARCHAR NOT NULL,
    PRODUCT_DESCRIPTION VARCHAR,
    PRODUCT_CATEGORY VARCHAR
);

CREATE OR REPLACE TABLE SRC_SCHEMA.TRANSACTIONS
(
    TRANSACTION VARIANT
);

COPY INTO SRC_SCHEMA.CUSTOMERS FROM @stage_convex_customers
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

COPY INTO SRC_SCHEMA.PRODUCTS FROM @stage_convex_products
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

COPY INTO SRC_SCHEMA.TRANSACTIONS FROM @stage_convex_transactions;

CREATE OR REPLACE PIPE CONVEXTEST.SRC_SCHEMA.CUSTOMERS_PIPE auto_ingest = true as
COPY INTO SRC_SCHEMA.CUSTOMERS FROM @stage_convex_customers
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

CREATE OR REPLACE PIPE CONVEXTEST.SRC_SCHEMA.PRODUCTS_PIPE auto_ingest = true as
COPY INTO SRC_SCHEMA.PRODUCTS FROM @stage_convex_products
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

CREATE OR REPLACE PIPE CONVEXTEST.SRC_SCHEMA.TRANSACTIONS_PIPE auto_ingest = true as
COPY INTO SRC_SCHEMA.TRANSACTIONS FROM @stage_convex_transactions;


CREATE OR REPLACE TABLE REP_SCHEMA.CUSTOMERS
AS(
    SELECT * FROM SRC_SCHEMA.CUSTOMERS
);

CREATE OR REPLACE TABLE REP_SCHEMA.PRODUCTS
AS(
    SELECT * FROM SRC_SCHEMA.PRODUCTS
);

CREATE OR REPLACE TEMPORARY TABLE SRC_SCHEMA.TRANSACTIONS_JSON_PARSED as
(
   select parse_json($1):basket  basket, parse_json($1):customer_id  customer_id, to_timestamp_ntz(parse_json($1):date_of_purchase ) date_of_purchase
         from SRC_SCHEMA.TRANSACTIONS t
);

CREATE OR REPLACE TABLE REP_SCHEMA.TRANSACTIONS_JSON_BUCKET_PARSED as(
select   f.value:price price, f.value:product_id product_id, t.customer_id customer_id, t.DATE_OF_PURCHASE DATE_OF_PURCHASE
         from SRC_SCHEMA.TRANSACTIONS_JSON_PARSED t,
        table(flatten(BASKET)) f
);

