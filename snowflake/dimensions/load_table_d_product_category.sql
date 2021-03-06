-- This script adds new product categories 
-- which might appear in the data or updates
-- when the categories were last observed in
-- the staging table.
merge into dimensions.d_product_category d
using 
(
  select
    product_category 
    , max(etl_source_key)         as etl_source_key
    , max(etl_source_row_number)  as etl_source_row_number
    , max(etl_time)               as etl_time
  from staging.products
  group by product_category
) stg
  on d.nk_product_category = stg.product_category
  when matched then 
    update 
    set d.update_time = sysdate(),
    d.etl_source_key = stg.etl_source_key,
    d.etl_source_row_number = stg.etl_source_row_number,
    d.etl_time = stg.etl_time
  when not matched then 
    insert(sk_product_category, nk_product_category, update_time, etl_source_key, etl_source_row_number, etl_time)
    values(seq_d_product_category_sk.nextval, stg.product_category, sysdate(), stg.etl_source_key, stg.etl_source_row_number, stg.etl_time);