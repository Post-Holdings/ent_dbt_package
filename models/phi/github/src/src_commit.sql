{{
  config(
    materialized='view',
    enabled=false
  )
}}

with source as (

    select * from {{ source('dbt_github', 'commit') }}

),

renamed as (

    select
        sha,
        repository_id,
        author_date,
        committer_date,
        author_email,
        author_name,
        committer_email,
        committer_name,
        message,
        _fivetran_synced

    from source

)

select * from renamed
