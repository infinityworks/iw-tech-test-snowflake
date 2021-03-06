-- This is the script which should be executed in normal runs;
-- i.e. when we already have the historic values of the d_customer
-- dimension.
-- This script deals with two scenario:
-- 1. the customer is new
-- 2. the customer exists but the loyalty score has changed
-- The merge handles adding new customers,
-- and "closing" customer records whose loyalty score is changed;
-- but it doesn't insert a new ("most recent") record for such customers.
-- that is handled by the subsequent insert.
merge into dimensions.d_customer d
using staging.customers stg
  on d.nk_customer_id = stg.customer_id
  and d.valid_to = to_timestamp('3000-01-01')
  when matched and d.loyalty_score != stg.loyalty_score then 
    update 
    set d.valid_to = date_trunc('day', sysdate()),
    d.is_most_recent = false
  when not matched then 
    insert(sk_customer_id, nk_customer_id, loyalty_score, valid_from, valid_to, is_most_recent, etl_source_key, etl_source_row_number, etl_time)
    values(seq_f_customers_sk.nextval, stg.customer_id, stg.loyalty_score, date_trunc('day', sysdate()), to_timestamp('3000-01-01'), True, stg.etl_source_key, stg.etl_source_row_number, stg.etl_time);

insert into dimensions.d_customer(sk_customer_id, nk_customer_id, loyalty_score, valid_from, valid_to, is_most_recent, etl_source_key, etl_source_row_number, etl_time)
select 
  seq_f_customers_sk.nextval
  , stg.customer_id
  , stg.loyalty_score
  , date_trunc('day', sysdate())
  , to_timestamp('3000-01-01')
  , True
  , stg.etl_source_key
  , stg.etl_source_row_number
  , stg.etl_time
from staging.customers stg
where (stg.customer_id, stg.loyalty_score) not in (select nk_customer_id, loyalty_score from dimensions.d_customer where is_most_recent);
