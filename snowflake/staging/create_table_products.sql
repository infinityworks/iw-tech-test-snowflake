create or replace transient table staging.products 
(
  product_id            varchar,
  product_description   varchar,
  product_category      varchar,
  etl_source_key        varchar,
  etl_source_row_number integer,
  etl_time              timestamp,
  constraint pk_stg_product_id primary key (product_id)
);
