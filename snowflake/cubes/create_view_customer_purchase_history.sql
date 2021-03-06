create or replace view cubes.customer_purchase_history as
  select
    tx.transaction_date_ts
    , c.nk_customer_id as customer_id
    , c.loyalty_score
    , p.nk_product_id as product_id
    , pc.nk_product_category as product_category
  from facts.f_transaction tx
  left outer join dimensions.d_customer c
    on c.sk_customer_id = tx.sk_customer_id
    and c.valid_from <= tx.transaction_date_ts
    and c.valid_to > tx.transaction_date_ts
  left outer join dimensions.d_product p
    on p.sk_product_id = tx.sk_product_id
  left outer join dimensions.d_product_category pc
    on p.sk_product_category = pc.sk_product_category;


