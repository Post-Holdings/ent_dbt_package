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
{% if  target.name in ["dev", "ci"] %}
    {%- set test_schema = target.schema -%}
{% else %}
     {%- set test_schema -%} {{env_var('DBT_TEST_SCHEMA')}} {%- endset -%}
{% endif %}

{{ generate_tests_stats(test_schema) }}

{% endsnapshot %}
