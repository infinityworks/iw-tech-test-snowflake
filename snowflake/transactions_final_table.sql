CREATE OR REPLACE  TABLE CONVEX_DB.INPUT_DATA.TRANSACTIONS_FINAL_TBL
AS
(
SELECT  
TRANS_JSON:customer_id::string AS CUSTOMER_ID 
,TRANS_JSON:date_of_purchase::datetime AS PURCHASE_DATE 
,value:price::float AS PRICE
,value:product_id::string as PRODUCT_ID
from "CONVEX_DB"."INPUT_DATA"."TRANSACTIONS_BASE_TBL" t
join lateral flatten( input => TRANS_JSON:basket ) b 
)
