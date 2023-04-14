

with source as (

    select * from {{ source('dbt_github', 'repository') }}

),

renamed as (

    select
        id,
        name,
        full_name,
        description,
        fork,
        archived,
        homepage,
        language,
        default_branch,
        created_at,
        watchers_count,
        forks_count,
        owner_id,
        private,
        _fivetran_synced

    from source

)

select * from renamed
