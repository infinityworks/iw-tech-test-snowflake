-- Disclaimer: This is not the correct way of loading data
-- for a fact table into a staging table. This script was
-- developped as it is due to the shortage of time, otherwise
-- the fact table loading should be an idempotent process
-- which only loads specific dates (for example "current date" or
-- a window from "current date - n" to "current date"), and the constructs
-- such as "current date" will be injected by the workflow execution engine
-- (e.g. Airflow) into a Jinja templated SQL script so that specific
-- S3 keys are targetted in each load (for example using the "d=YYYY-MM-DD" pattern
-- in the S3 key)
-- Note: I haven't used external tables here because they need to be refreshed to
-- be able to pick up the new transaction data. I didn't have time to set the refresh
-- mechanism up.
create or replace transient table staging.transactions cluster by (transaction_date) as
with raw_tx as (
  select
      parse_json(t.$1):date_of_purchase::date         as transaction_date
      , parse_json(t.$1):date_of_purchase::timestamp  as transaction_date_ts
      , parse_json(t.$1):customer_id::varchar         as customer_id
      , parse_json(t.$1):basket                       as basket_json
      , metadata$filename                             as etl_source_key
      , metadata$file_row_number                      as etl_source_row_number
      , current_timestamp()                           as etl_time
    from @staging.convex_data/transactions/ (file_format => staging.convex_json) t
)
select 
    r.transaction_date
    , transaction_date_ts
    , customer_id
    , f.value:product_id::varchar as product_id
    , f.value:price::number       as price
    , etl_source_key
    , etl_source_row_number
    , etl_time
from raw_tx r,
table(flatten(r.basket_json)) f;
