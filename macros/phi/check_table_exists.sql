{%- macro check_table_exists(schema_name, table_name) -%}

{% set table_exists_query %}
SELECT EXISTS( SELECT * FROM information_schema.tables 
WHERE lower(table_name) = lower('{{ table_name }}')
AND lower(table_schema) = lower('{{ schema_name }}')
) as table_exists
order by 1
{% endset %}

{% set results = run_query(table_exists_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}


{%- set results_list_out = results_list[0] | string() -%}

{% if results_list_out | string() == 'True' %}

{{ return('True') }}

{% else %}
{# Table do not exists #}

{{ return('False') }}

{% endif %}

{% endmacro %}
