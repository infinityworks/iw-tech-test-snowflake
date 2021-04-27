  copy into txns_json
  from @s3_txns
  
  copy into products
  from @s3_products
  
  copy into customers
  from @s3_customers