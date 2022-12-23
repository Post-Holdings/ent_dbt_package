---Use following syntax to call this macro for comaprison of two table columns
---dbt run-operation test_compare_all_columns --args '{table_a: adr_customer_master_dim, table_b: conv_adr_customer_master_dim, pk: CUSTOMER_ADDRESS_NUMBER_GUID, exclude_columns: "CUSTOMER_ADDRESS_NUMBER_GUID_OLD,DATE_INSERTED,DATE_UPDATED"}'
{% macro test_compare_all_columns(table_a,table_b,pk,exclude_columns) %}

{%- set columns_to_compare=adapter.get_columns_in_relation(ref(table_a))  -%}

{%- set excluded_columns=exclude_columns -%}

{% set old_etl_relation_query %}
    select * from {{ ref(table_b) }}
{% endset %}

{% set new_etl_relation_query %}
    select * from {{ ref(table_a) }}
{% endset %}

{% if execute %}
    
        {% for column in columns_to_compare %}
            {{ log('Comparing column "' ~ column.name ~'"', info=True) }}

            {% if column.name not in excluded_columns %}
                {% set audit_query = audit_helper.compare_column_values(
                    a_query=old_etl_relation_query,
                    b_query=new_etl_relation_query,
                    primary_key=pk,
                    column_to_compare=column.name
                ) %}
                
                {% set audit_results = run_query(audit_query) %}

                {% do log(audit_results.column_names, info=True) %}
                    {% for row in audit_results.rows %}
                        {% do log(row.values(), info=True) %}
                    {% endfor %}

            {% endif %}
        {% endfor %}    
{% endif %}
{% endmacro %}