/*
  --add "{{ test_results_history(results) }}" to an on-run-end: block in dbt_project.yml to load test_results_history table with data test results
*/
{% macro test_results_history(results) %}

  {%- set store_test_results_flag -%} {{env_var('DBT_STORE_TEST_RESULTS')}} {%- endset -%}
  {% if store_test_results_flag == 'YES' %}

    {%- set central_tbl -%} {{ target.schema }}.test_results_central {%- endset -%}
    {%- set history_tbl -%} {{env_var('DBT_TEST_SCHEMA')}}.test_results_history {%- endset -%}
    
    {{ log("Centralizing test data in " + central_tbl, info = true) if execute }}

    {% if target.name != 'default' %}
    
        {% for result in results if result.node.resource_type == 'test' and ('test_step_by_step' in result.node.raw_sql or 'test_time_travel' in result.node.raw_sql) %}

            create table if not exists {{ history_tbl }} (
                INVOCATION_ID VARCHAR(16777216),
                NODE_ID VARCHAR(16777216),
                TEST_NAME VARCHAR(16777216),
                TEST_NAME_LONG VARCHAR(16777216),
                TEST_TYPE VARCHAR(16777216),
                MODEL_REFS VARCHAR(16777216),
                SOURCE_REFS VARCHAR(16777216),
                TEST_SEVERITY_CONFIG VARCHAR(16777216),
                EXECUTION_TIME_SECONDS VARCHAR(16777216),
                TEST_RESULT VARCHAR(16777216),
                FILE_TEST_DEFINED VARCHAR(16777216),
                TEST_TABLE_NAME VARCHAR(16777216),
                TABLE_A_NAME VARCHAR(16777216),
                TABLE_B_NAME VARCHAR(16777216),
                TABLE_A_COUNT VARCHAR(16777216),
                TABLE_B_COUNT VARCHAR(16777216),
                COUNT_DIFF VARCHAR(16777216),
                COL_1_NAME VARCHAR(16777216),
                TABLE_A_VALUE_1 VARCHAR(16777216),
                TABLE_B_VALUE_1 VARCHAR(16777216),
                COL_1_DIFF VARCHAR(16777216),
                COL_2_NAME VARCHAR(16777216),
                TABLE_A_VALUE_2 VARCHAR(16777216),
                TABLE_B_VALUE_2 VARCHAR(16777216),
                COL_2_DIFF VARCHAR(16777216),
                COL_3_NAME VARCHAR(16777216),
                TABLE_A_VALUE_3 VARCHAR(16777216),
                TABLE_B_VALUE_3 VARCHAR(16777216),
                COL_3_DIFF VARCHAR(16777216),
                TEST_STATUS VARCHAR(16777216),
                VARIANCE_PCT_THRESHOLD VARCHAR(16777216),
                _TIMESTAMP TIMESTAMP_LTZ(9)
            );

            insert into {{ history_tbl }} 
            
            {% set test_name='' %}
            {% set test_type='' %}

            {% if result.node.test_metadata is defined %}
                {% set test_name = result.node.test_metadata.name %}
                {% set test_type='generic' %}
            {% elif result.node.name is defined %}
                {% set test_name = result.node.name %}
                {% set test_type='singular' %}
            {% endif %}

            select 
                '{{ invocation_id }}'::text as invocation_id,
                '{{ result.node.unique_id }}'::text as node_id,
                '{{ test_name }}'::text as test_name,
                '{{ result.node.name }}'::text as test_name_long,
                '{{ test_type }}'::text as test_type,
                '{{ process_refs(result.node.refs) }}'::text as model_refs,
                '{{ process_refs(result.node.sources, is_src=true) }}'::text as source_refs,
                '{{ result.node.config.severity }}'::text as test_severity_config,
                '{{ result.execution_time }}'::text as execution_time_seconds,
                '{{ result.status }}'::text as test_result,
                '{{ result.node.original_file_path }}'::text as file_test_defined, 
                '{{ result.node.relation_name }}'::text as test_table_name,
                table_a_name::text as table_a_name,
                table_b_name::text as table_b_name,
                table_a_count::text as table_a_count,
                table_b_count::text as table_b_count,
                table_b_count::text as count_diff,
                col_1_name::text as col_1_name,
                table_a_value_1::text as table_a_value_1,
                table_b_value_1::text as table_b_value_1,
                col_1_diff::text as col_1_diff,
                col_2_name::text as col_2_name,
                table_a_value_2::text as table_a_value_2,
                table_b_value_2::text as table_b_value_2,
                col_2_diff::text as col_2_diff,
                col_3_name::text as col_3_name,
                table_a_value_3::text as table_a_value_3,
                table_b_value_3::text as table_b_value_3,
                col_3_diff::text as col_3_diff,
                test_status::text as test_status,
                variance_pct_threshold::text as variance_pct_threshold,
                current_timestamp as _timestamp
            from {{ result.node.relation_name }}
        
            ;

        {% endfor %}

    {% endif %}

  {% endif %}

{% endmacro %}
