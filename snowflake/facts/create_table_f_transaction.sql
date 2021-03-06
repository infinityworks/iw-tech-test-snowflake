-- transaction_date is chosen as the cluster key considering
-- the normal requirements of such a table in production.
-- Although for the existing volume of the test data, the performance
-- would have been sufficiently good, even if we don't define a cluster key
create table if not exists facts.f_transaction cluster by(transaction_date)
(
  transaction_date        date,
  transaction_date_ts     timestamp,
  sk_customer_id          integer,
  sk_product_id           integer,
  price                   number,
  etl_source_key          varchar,
  etl_source_row_number   integer,
  etl_time                timestamp,
  constraint pk_f_transaction primary key(transaction_date_ts, sk_customer_id, sk_product_id),
  constraint fk_d_customer_sk foreign key(sk_customer_id) references dimensions.d_customer(sk_customer_id),
  constraint fk_d_product_sk foreign key(sk_product_id) references dimensions.d_product(sk_product_id)
);