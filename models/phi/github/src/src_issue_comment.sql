{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'issue_comment') }}

),

renamed as (

    select
        id,
        issue_id,
        body,
        created_at,
        updated_at,
        user_id,
        _fivetran_synced

    from source

)

select * from renamed
