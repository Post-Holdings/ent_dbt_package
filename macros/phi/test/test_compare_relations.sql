---Use following syntax to call this macro for comparison of two tables
---dbt run-operation test_compare_relations --args '{dbt_table: adr_customer_master_dim, old_table: conv_adr_customer_master_dim, primary_key: CUSTOMER_ADDRESS_NUMBER_GUID, exclude_columns: "CUSTOMER_ADDRESS_NUMBER_GUID_OLD,DATE_INSERTED,DATE_UPDATED"}'
{% macro test_compare_relations(dbt_table,old_table,primary_key,exclude_columns) %}

{% set old_etl_relation=ref(old_table) %}

{% set dbt_relation=ref(dbt_table) %}

{% set audit_query = audit_helper.compare_relations(
    a_relation=old_etl_relation,
    b_relation=dbt_relation,
    exclude_columns=exclude_columns,
    primary_key=primary_key
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