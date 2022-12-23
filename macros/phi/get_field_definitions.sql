{% macro get_field_definitions(database_name, schema_name, table_name) %}
    {% set query %}
       select
           COLUMN_NAME as field_name,
           case when DATA_TYPE = 'TEXT' THEN lower( 'cast(substring(' || COLUMN_NAME || ',1,' || CHARACTER_MAXIMUM_LENGTH || ') as ' || DATA_TYPE || '(' || CHARACTER_MAXIMUM_LENGTH || ') ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'NUMBER' AND lower(field_name) like '%guid%' THEN lower( 'cast(' || COLUMN_NAME || ' as text(255) ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'NUMBER' AND lower(field_name) not like '%guid%' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || '(' || NUMERIC_PRECISION || ',' || NUMERIC_SCALE || ') ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'TIMESTAMP_NTZ' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || '(' || DATETIME_PRECISION || ') ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'TIMESTAMP_LTZ' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || '(' || DATETIME_PRECISION || ') ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'DATE' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || ') as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'FLOAT' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || ') ) as ' || COLUMN_NAME ) 
            when DATA_TYPE = 'BOOLEAN' THEN lower( 'cast(' || COLUMN_NAME || ' as ' || DATA_TYPE || ') ) as ' || COLUMN_NAME ) 
            else NULL 
            END as field_type
       from {{ database_name }}."INFORMATION_SCHEMA"."COLUMNS" 
WHERE lower(table_name) = lower('{{ table_name }}')
AND lower(table_schema) = lower('{{ schema_name }}')
    {% endset %} 

    {% set query_results = run_query(query) %}

    {% if execute %}
        {% set results = query_results.rows %}
        {{ return(results) }}
    {% endif %}
{% endmacro %}