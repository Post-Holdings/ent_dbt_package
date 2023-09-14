{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'user') }}

),

renamed as (

    select
        id,
        login,
        type,
        site_admin,
        name,
        company,
        blog,
        location,
        hireable,
        bio,
        created_at,
        updated_at,
        _fivetran_synced

    from source

)

select * from renamed
