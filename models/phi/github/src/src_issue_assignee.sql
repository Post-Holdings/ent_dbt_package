{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'issue_assignee') }}

),

renamed as (

    select
        issue_id,
        user_id,
        _fivetran_synced

    from source

)

select * from renamed
