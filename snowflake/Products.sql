USE database CONVEX_DB;
USE SCHEMA INPUT_DATA;

--Creation of the stage based on Amazon S3 Bucket
--products
CREATE OR REPLACE STAGE stage_products
STORAGE_INTEGRATION = storage_convex
url='s3://s3-bucket-convex-test/input_data/products/';

--Check list of files to be staged
LIST @stage_products;

--Copy info from stage to final table in the right format
COPY INTO INPUT_DATA.PRODUCTS_TBL 
FROM @stage_convex_products
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);

--Checking data
SELECT * FROM INPUT_DATA.PRODUCTS_TBL;

--Creation of the pipeline, with the option to automatically process the file as it is ready to load 
CREATE OR REPLACE PIPE CONVEX_DB.INPUT_DATA.PRODUCTS_PIPE
AUTO_INGEST = TRUE as
COPY INTO INPUT_DATA.PRODUCTS_TBL 
FROM @stage_products
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',', SKIP_HEADER = 1);
