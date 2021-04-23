with source as (

    select * from {{ source('infinity_works', 'products') }}

),

renamed as (

    select
        product_id,
        product_description,
        product_category

    from source

)

select * from renamed