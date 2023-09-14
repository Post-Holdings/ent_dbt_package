{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'issue_closed_history') }}

),

renamed as (

    select
        issue_id,
        updated_at,
        closed,
        actor_id,
        commit_sha,
        _fivetran_synced

    from source

)

select * from renamed
