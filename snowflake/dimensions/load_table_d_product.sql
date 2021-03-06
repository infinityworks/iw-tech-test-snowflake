merge into dimensions.d_product d
using 
(
  select
    sp.product_id
    , sp.product_description
    , nvl(pc.sk_product_category, -1) as sk_product_category
    , sp.etl_source_key
    , sp.etl_source_row_number
    , sp.etl_time      
  from staging.products sp
  left outer join dimensions.d_product_category pc
    on sp.product_category = pc.nk_product_category
) stg
  on d.nk_product_id = stg.product_id
  when matched 
  and (
    d.product_description != stg.product_description
    or d.sk_product_category != stg.sk_product_category
  )
  then 
    update 
    set d.update_time = sysdate(),
    d.product_description = stg.product_description,
    d.sk_product_category = stg.sk_product_category,
    d.etl_source_key = stg.etl_source_key,
    d.etl_source_row_number = stg.etl_source_row_number,
    d.etl_time = stg.etl_time
  when not matched then 
    insert(sk_product_id, nk_product_id, product_description, sk_product_category, update_time, etl_source_key, etl_source_row_number, etl_time)
    values(seq_d_product_sk.nextval, stg.product_id, stg.product_description, stg.sk_product_category, sysdate(), stg.etl_source_key, stg.etl_source_row_number, stg.etl_time);
