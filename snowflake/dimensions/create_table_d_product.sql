-- product is a type 1 dimension.
-- You could argue that a change in product category
-- should be treated as a type 2 change, but I didn't
-- had the time to do it and I already had created a type 2
-- example for d_customer
create sequence seq_d_product_sk start = 1 increment = 1;

create table if not exists dimensions.d_product
(
  sk_product_id         integer,
  nk_product_id         varchar,
  product_description   varchar,
  sk_product_category   integer,
  update_time           timestamp,
  etl_source_key        varchar,
  etl_source_row_number integer,
  etl_time              timestamp,
  constraint pk_d_product primary key (sk_product_id),
  constraint fk_d_product_category_sk foreign key(sk_product_category) 
    references dimensions.d_product_category(sk_product_category)
);
