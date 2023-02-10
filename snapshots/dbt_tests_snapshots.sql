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

{%- set test_schema -%} {{env_var('DBT_TEST_SCHEMA')}} {%- endset -%}

{{ generate_tests_stats(test_schema) }}

{% endsnapshot %}
