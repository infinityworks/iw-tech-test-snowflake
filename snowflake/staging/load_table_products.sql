truncate table staging.products;

copy into staging.products(product_id, product_description, product_category, etl_source_key, etl_source_row_number, etl_time)
from (
  select 
    p.$1                        as product_id
    , p.$2                      as product_description
    , p.$3                      as product_category
    , metadata$filename         as etl_source_key
    , metadata$file_row_number  as etl_source_row_number
    , current_timestamp()       as etl_time      
  from @staging.convex_data/products.csv p
)
file_format = staging.convex_csv;
