-- product category is a type 1 dimension.
-- It could be regarded as an "over-engineered" but
-- I think it can add to the potential of the data model
-- to be expandable in the future.
create sequence seq_d_product_category_sk start = 1 increment = 1;

create table if not exists dimensions.d_product_category(
  sk_product_category   integer,
  nk_product_category   varchar,
  update_time           timestamp,
  etl_source_key        varchar,
  etl_source_row_number integer,
  etl_time              timestamp,
  constraint pk_d_product_category primary key (sk_product_category)
);