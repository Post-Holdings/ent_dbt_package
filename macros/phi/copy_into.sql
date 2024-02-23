{% macro copy_into(table_name,stage_db_name,stage_schema_name,stage,pattern,fileformat,skipheader,onerror,force=false) %}

    {{ log("Loading data from blob stage", False) }}
    BEGIN;
    COPY INTO {{ table_name }}
    FROM @{{ stage_db_name }}.{{ stage_schema_name }}.{{ stage }}  
    PATTERN='{{ pattern }}'
    FILE_FORMAT = (FORMAT_NAME='{{ target.database }}.{{ stage_schema_name }}.{{ fileformat }}' SKIP_HEADER = {{ skipheader }})
    ON_ERROR = '{{ onerror }}' 
    FORCE = {{ force }};
    COMMIT;
    {{ log("Loaded data fom blob stage", False) }}

{% endmacro %}
