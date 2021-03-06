-- Again, similar to the "disclaimer" for the staging table,
-- this is admittedly not the correct way of loading a fact table
-- and this script was written in a way to only help me finish 
-- the task on time.
-- The correct approach would be creating the fact table data in an
-- idempotent way so that repeating the process doesn't lead to creation
-- of duplicated data. Also a proper fact load process is always targeting
-- a specific window of data (in this case using "transaction_date"); i.e.
-- we have a daily/hourly DAG which is either only loading the data which was
-- generated in the previous day/hour or a window based on the "previous day/hour."
-- This statement is only suitable for a one-off test execution.

insert into facts.f_transaction
select
    stg.transaction_date
    , stg.transaction_date_ts
    , nvl(c.sk_customer_id, -1) as sk_customer_id
    , nvl(p.sk_product_id, -1) as sk_product_id
    , stg.price
    , stg.etl_source_key
    , stg.etl_source_row_number
    , stg.etl_time
from staging.transactions stg
left outer join dimensions.d_customer c
    on stg.customer_id = c.nk_customer_id
left outer join dimensions.d_product p
    on stg.product_id = p.nk_product_id;
