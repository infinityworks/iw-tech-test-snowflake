-- due to the fact that the dimension data is coming from
-- one file, we can easily change this method and use external 
-- tables.

truncate table staging.customers;

copy into staging.customers(customer_id, loyalty_score, etl_source_key, etl_source_row_number, etl_time)
from 
(
  select 
    c.$1                        as customer_id
    , c.$2                      as loyalty_score 
    , metadata$filename         as etl_source_key
    , metadata$file_row_number  as etl_source_row_number
    , current_timestamp()       as etl_time      
  from @staging.convex_data/customers.csv c
)
file_format = staging.convex_csv;
