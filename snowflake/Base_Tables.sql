--Snowflake
--Table Creation

CREATE DATABASE CONVEX_DB;
CREATE SCHEMA CONVEX_DB.INPUT_DATA;

CREATE OR REPLACE TABLE CONVEX_DB.INPUT_DATA.CUSTOMERS_TBL 

(
CUSTOMER_ID STRING
,LOYALTY_SCORE INT
)
;

 CREATE OR REPLACE TABLE CONVEX_DB.INPUT_DATA.PRODUCTS_TBL
 (
  PRODUCT_ID STRING
  ,PRODUCT_DESCRIPTION STRING
  ,PRODUCT_CATEGORY STRING
 )
;

 CREATE OR REPLACE TABLE CONVEX_DB.INPUT_DATA.TRANSACTIONS_BASE_TBL
 (
  TRANS_JSON VARIANT
 )
