{{
  config(
    materialized = 'view',
    )
}}

with customers as (
    select * from {{ ref('stg_infinity_works__customers') }}
),


products as (
    select * from {{ ref('stg_infinity_works__products') }}
),

transactions as (
    select * from {{ ref('stg_infinity_works__transactions') }}
),

transactions_flattened as (
    select
        customer_id,

        basket.value:price::number as price,
        basket.value:product_id::string as product_id

    from
        transactions,

        lateral flatten(input => basket_items) as basket
),

purchases_grouped as (
    select
        customer_id,
        product_id,

        count(*) as purchase_count

    from transactions_flattened

    group by 1, 2
),

final as (
    select
        customers.customer_id,
        customers.loyalty_score,
        products.product_id,
        products.product_category,
        purchases_grouped.purchase_count

        from customers

        inner join purchases_grouped on customers.customer_id = purchases_grouped.customer_id

        inner join products on purchases_grouped.product_id = products.product_id

)

select * from final