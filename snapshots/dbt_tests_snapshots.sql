{% snapshot dbt_tests_snapshots %}

{{
    config(
        tags=['tests'],
        strategy='timestamp',
        unique_key='test_name',
        updated_at='snapshot_date',
        target_schema= env_var('DBT_TEST_SCHEMA')
    )
}}

-- Set schema, since tests use custom schema on dev
{%- set test_schema -%} {{env_var('DBT_TEST_SCHEMA')}} {%- endset -%}

{{ generate_tests_stats(test_schema) }}

{% endsnapshot %}
