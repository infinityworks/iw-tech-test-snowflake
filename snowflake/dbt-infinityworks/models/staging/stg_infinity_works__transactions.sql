with source as (

    select * from {{ source('infinity_works', 'transactions') }}

),

renamed as (

    select
        transaction_detail:customer_id::string as customer_id,
        transaction_detail:date_of_purchase::timestamp_ntz as purchased_at,
        transaction_detail:basket as basket_items

    from source

)

select * from renamed