INGEST_TRANSACTIONS = """
COPY INTO {DB}.STAGING.TRANSACTIONS(
PAYLOAD,
FILE_KEY,
INSERTED_TIMESTAMP
)
FROM (
select
$1::variant,
METADATA$FILENAME::VARCHAR,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from @{DB}.STAGING.TRANSACTIONS_JSON
);
"""


INGEST_CUSTOMERS = """
COPY INTO {DB}.STAGING.CUSTOMERS (
customer_id,
loyalty_score,
FILE_KEY,
INSERTED_TIMESTAMP
)
from (
select
$1::variant as customer_id,
$2::variant as loyalty_score,
METADATA$FILENAME::VARCHAR,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from @{DB}.STAGING.CUSTOMERS_CSV
);
"""


INGEST_PRODUCTS = """
COPY INTO {DB}.STAGING.PRODUCTS (
product_id,
product_description,
product_category,
FILE_KEY,
INSERTED_TIMESTAMP
)
from (
select
$1::variant as product_id,
$2::variant as product_description,
$3::variant as product_category,
METADATA$FILENAME::VARCHAR,
convert_timezone('Europe/London',CURRENT_TIMESTAMP())::TIMESTAMP_TZ
from @{DB}.STAGING.PRODUCTS_CSV);
"""