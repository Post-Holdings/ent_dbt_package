---Use following syntax to call this macro for comparison of a column in two different tables
---dbt run-operation test_compare_single_column --args '{table_a: adr_customer_master_dim, table_b: conv_adr_customer_master_dim, pk: CUSTOMER_ADDRESS_NUMBER_GUID, compare_column: "UNIFIED_CUSTOMER"}'
{% macro test_compare_single_column(table_a,table_b,pk,compare_column) %}


{% set old_etl_relation_query %}
    select * from {{ ref(table_b) }}
{% endset %}

{% set new_etl_relation_query %}
    select * from {{ ref(table_a) }}
{% endset %}

{% set audit_query = audit_helper.compare_column_values(
    a_query=old_etl_relation_query,
    b_query=new_etl_relation_query,
    primary_key=pk,
    column_to_compare=compare_column
) %}

{% set audit_results = run_query(audit_query) %}

{% if execute %}
{% do audit_results.print_table() %}
{% do log(audit_results.column_names, info=True) %}
    {% for row in audit_results.rows %}
        {% do log(row.values(), info=True) %}
    {% endfor %}
{% endif %}

{% endmacro %}