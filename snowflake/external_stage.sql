  create or replace stage s3_txns 
  storage_integration = convex_s3_encrypted_int
  url='s3://convex-s3-encrypted/transactions/'
  file_format = json_file_format
  
  create or replace stage s3_customers
  storage_integration = convex_s3_encrypted_int
  url='s3://convex-s3-encrypted/customers/'
  file_format = csv_file_format
  
  create or replace stage s3_products 
  storage_integration = convex_s3_encrypted_int
  url='s3://convex-s3-encrypted/products/'
  file_format = csv_file_format