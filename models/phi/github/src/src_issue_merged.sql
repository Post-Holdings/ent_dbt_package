

with source as (

    select * from {{ source('dbt_github', 'issue_merged') }}

),

renamed as (

    select
        commit_sha,
        issue_id,
        merged_at,
        actor_id,
        _fivetran_synced

    from source

)

select * from renamed
