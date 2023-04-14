{{
  config(
    materialized=env_var('DBT_MAT_VIEW'),
    on_schema_change='sync_all_columns',
    enabled=true
  )
}}

with source as (

    select * from {{ source('dbt_tests', 'test_results_history') }}

),

renamed as (

    select
        invocation_id,
        node_id,
        test_name,
        test_name_long,
        test_type,
        model_refs,
        source_refs,
        test_severity_config,
        execution_time_seconds,
        test_result,
        file_test_defined,
        test_table_name,
        table_a_name,
        table_b_name,
        table_a_count,
        table_b_count,
        count_diff,
        col_1_name,
        table_a_col_1_value,
        table_b_col_1_value,
        col_1_diff,
        col_2_name,
        table_a_col_2_value,
        table_b_col_2_value,
        col_2_diff,
        col_3_name,
        table_a_col_3_value,
        table_b_col_3_value,
        col_3_diff,
        test_status,
        variance_pct_threshold,
        _timestamp

    from source

)

select * from renamed
