  create or replace  view vw_transactions_json_flattened 
  as
  select  json_str:customer_id::string as customer_id ,
  json_str:date_of_purchase::datetime as date_of_purchase ,
  value:price::float as price,
  value:product_id::string as product_id
  
  from txns_json t
  join lateral flatten( input => json_str:basket ) b ;
  