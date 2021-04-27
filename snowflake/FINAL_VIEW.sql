  create or replace view vw_agg_transactions as 
  select c.customer_id,
  c.loyalty_score,
  p.product_id,
  p.product_category,
  count(1) as purchase_count
  
  from vw_transactions_json_flattened t
  inner join customers c on c.customer_id=t.customer_id
  inner join products p on p.product_id=t.product_id
  group by c.customer_id,c.loyalty_score,p.product_id,p.product_category
  order by c.customer_id,c.loyalty_score,p.product_id,p.product_category