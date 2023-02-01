{%- macro generate_tests_stats(schema) -%} 


    {# Check all tables in the provided tests schema #}
    {%- call statement('tests_tables_query', fetch_result=True) %}

        select
            t.table_name as table_name,
            t.last_altered as modified_date
        from information_schema.tables t
        where upper(t.table_schema) = upper('{{env_var('DBT_TEST_SCHEMA')}}')
        order by table_name

    {%- endcall -%}

    {# Query and save result in table_list var #}
    {%- set table_list = load_result('tests_tables_query')['data'] -%}

    {# Check if there are any results #}
    {%- if table_list -%}

        {# Define count(*) query and execute for all tables in the schema #}
        {%- for table_name in table_list -%}

            {%- call statement('tests_table_count', fetch_result=True) %}

                select
                    count(*)
                from {{ schema }}.{{ table_name[0] }}

            {%- endcall -%}

            {%- set count_result = load_result('tests_table_count')['data'] -%}

            SELECT 
                '{{ table_name[0] }}' as test_name,
                TO_TIMESTAMP_TZ(('{{ table_name[1] }}') as snapshot_date,
                {{ count_result[0][0]|round|int }} as failure_count 


            {% if not loop.last %}

                UNION ALL


            {% endif %}

        {%- endfor -%}


    {%- else -%}

        {{ return([]) }}

    {%- endif -%}


{% endmacro %}
