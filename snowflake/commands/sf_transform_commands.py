PERSIST = ["""
insert into {DB}.persist.customers
select 
s.CUSTOMER_ID, 
s.LOYALTY_SCORE,
s.file_key,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from {DB}.staging.customers s
where
s.INSERTED_TIMESTAMP >= (select ifnull(max(INSERTED_TIMESTAMP),(select min(INSERTED_TIMESTAMP) from {DB}.staging.customers)) from {DB}.persist.CUSTOMERS);
""",

"""
insert into {DB}.persist.products
select 
s.product_id,
s.product_description,
s.product_category,
s.file_key,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from {DB}.staging.products s
where
s.INSERTED_TIMESTAMP >= (select ifnull(max(INSERTED_TIMESTAMP),(select min(INSERTED_TIMESTAMP) from {DB}.staging.products)) from {DB}.persist.products);
""",

"""
insert into {DB}.persist.transactions
select 
s.payload:customer_id::string,
f1.value:price::number,
f1.value:product_id::string,
s.payload:date_of_purchase::datetime,
s.file_key,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from {DB}.staging.transactions s,
lateral flatten(input => s.payload, path => 'basket') f1
where
s.INSERTED_TIMESTAMP >= (select ifnull(max(INSERTED_TIMESTAMP),(select min(INSERTED_TIMESTAMP) from {DB}.staging.transactions)) from {DB}.persist.transactions);
"""]

ANALYTICS = ["""
create or replace view {DB}.analytics.single_view as
select
t.customer_id,
c.loyalty_score,
t.product_id,
p.product_category,
count(t.file_Key) purchase_count
from {DB}.persist.transactions t
join {DB}.persist.customers c on t.customer_id = c.customer_id
join {DB}.persist.products p on p.product_id = t.product_id
group by 1,2,3,4
;
"""]