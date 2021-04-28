  create or replace table txns_json (json_str variant)
  
  create or replace table products(product_id string,
                                    product_description string,
                                    product_category string)
  
  create or replace table customers(customer_id string,
                                    loyalty_score int)