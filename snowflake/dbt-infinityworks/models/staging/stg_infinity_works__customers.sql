with source as (

    select * from {{ source('infinity_works', 'customers') }}

),

renamed as (

    select
        customer_id,
        loyalty_score

    from source

)

select * from renamed
