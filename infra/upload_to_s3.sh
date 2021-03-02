aws s3 sync ./input_data/starter/transactions/ s3://bottega-snowflake/transactions/ --profile personal_account
aws s3 cp ./input_data/starter/customers.csv s3://bottega-snowflake/customers/customers.csv --profile personal_account
aws s3 cp ./input_data/starter/products.csv s3://bottega-snowflake/products/products.csv --profile personal_account
