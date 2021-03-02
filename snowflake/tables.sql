use schema demo_db.staging;

create or replace external table customers
(
    customer_id varchar as (value:c1::varchar),
    loyalty_score int as (value:c2::int)
)
LOCATION = @s3_stage_csv
FILE_FORMAT = (type = CSV SKIP_HEADER = 1)
PATTERN = '.*customers.csv';

create or replace external table products
(
    product_id varchar as (value:c1::varchar),
    product_description varchar as (value:c2::varchar),
    product_category varchar as (value:c3::varchar)
)
LOCATION = @s3_stage_csv
FILE_FORMAT = (type = CSV SKIP_HEADER = 1)
PATTERN = '.*products.csv';

create or replace table transactions (data variant);

create or replace pipe transactions_pipe auto_ingest=true as
copy into transactions
from @s3_stage_json
pattern = '.*transactions.json'