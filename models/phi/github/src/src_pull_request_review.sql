

with source as (

    select * from {{ source('dbt_github', 'pull_request_review') }}

),

renamed as (

    select
        id,
        pull_request_id,
        body,
        submitted_at,
        state,
        user_id,
        commit_sha,
        _fivetran_synced

    from source

)

select * from renamed
