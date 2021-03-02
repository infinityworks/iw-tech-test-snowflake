use schema demo_db.staging;

create or replace view transactions_flat as
select 
  data:"customer_id"::string customer_id,
  data:"date_of_purchase"::datetime date_of_purchase,
  value:"price"::number price,
  value:"product_id"::string product_id 
from transactions, lateral flatten(input => data:basket);

create schema demo_db.insights;

use schema demo_db.insights;

create or replace view purchase_count as
select 
    t.customer_id,
    c.loyalty_score,
    t.product_id,
    p.product_category,
    count(1) as purchase_count
from staging.transactions_flat t
left join staging.customers c
on t.customer_id = c.customer_id
left join staging.products p
on t.product_id = p.product_id
group by
    t.customer_id,
    c.loyalty_score,
    t.product_id,
    p.product_category;
