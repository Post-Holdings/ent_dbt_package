

with source as (

    select * from {{ source('dbt_github', 'issue') }}

),

renamed as (

    select
        id,
        created_at,
        updated_at,
        number,
        state,
        title,
        body,
        locked,
        closed_at,
        repository_id,
        milestone_id,
        pull_request,
        user_id,
        _fivetran_synced

    from source

)

select * from renamed
