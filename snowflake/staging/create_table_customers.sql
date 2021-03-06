create or replace transient table staging.customers 
(
  customer_id           varchar,
  loyalty_score         integer,
  etl_source_key        varchar,
  etl_source_row_number integer,
  etl_time              timestamp,
  constraint pk_stg_customer_id primary key (customer_id)
);