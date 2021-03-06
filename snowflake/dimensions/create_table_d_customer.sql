create sequence seq_d_customers_sk start = 1 increment = 1;

create table if not exists dimensions.d_customer
(
  sk_customer_id        integer not null,
  nk_customer_id        varchar not null,
  loyalty_score         integer,
  valid_from            timestamp,
  valid_to              timestamp,
  is_most_recent        boolean,
  etl_source_key        varchar,
  etl_source_row_number integer,
  etl_time              timestamp,
  constraint pk_d_customer_id primary key (sk_customer_id)
);
