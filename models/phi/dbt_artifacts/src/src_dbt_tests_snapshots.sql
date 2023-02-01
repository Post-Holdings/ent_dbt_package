with source as (

    select * from {{ source('snapshots', 'dbt_tests_snapshots') }}

),

renamed as (

    select
        test_name,
        snapshot_date,
        failure_count,
        dbt_scd_id,
        dbt_updated_at,
        dbt_valid_from,
        dbt_valid_to

    from source
)

select * from renamed
