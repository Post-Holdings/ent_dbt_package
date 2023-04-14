

with source as (

    select * from {{ source('dbt_github', 'commit_pull_request') }}

),

renamed as (

    select
        commit_sha,
        pull_request_id,
        _fivetran_synced

    from source

)

select * from renamed
