{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'user_email') }}

),

renamed as (

    select
        email,
        user_id,
        name,
        _fivetran_synced

    from source

)

select * from renamed
