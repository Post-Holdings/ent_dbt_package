

with source as (

    select * from {{ source('dbt_github', 'pull_request') }}

),

renamed as (

    select
        id,
        issue_id,
        merge_commit_sha,
        draft,
        head_label,
        head_ref,
        head_sha,
        head_repo_id,
        head_user_id,
        base_label,
        base_ref,
        base_sha,
        base_repo_id,
        base_user_id,
        _fivetran_synced

    from source

)

select * from renamed
