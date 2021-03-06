-- This script should be executed to populate the historic values
-- of this type 2 dimension and should ONLY be executed for the 
-- first run!
-- Because we don't have the history of the type 2 dimension d_customer,
-- we extract it from the history of transactions, therefore this dimension
-- can only be populated after the transactions are staged.
insert into dimensions.d_customer(sk_customer_id, nk_customer_id, loyalty_score, valid_from, valid_to, is_most_recent, etl_source_key, etl_source_row_number, etl_time)
with earliest_customer_tx as 
(
  select 
    customer_id
    , date_trunc('day', min(transaction_date_ts::timestamp)) as valid_from
  from staging.transactions 
  group by customer_id
)
select
  seq_f_customers_sk.nextval
  , stg.customer_id
  , stg.loyalty_score
  , valid_from
  , to_timestamp('3000-01-01')
  , True
  , stg.etl_source_key
  , stg.etl_source_row_number
  , stg.etl_time
from staging.customers stg
join earliest_customer_tx tx
    on tx.customer_id = stg.customer_id;
