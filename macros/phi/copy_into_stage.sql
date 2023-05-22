{% macro copy_into_stage(table_name,stage_db_name,stage_schema_name,stage,filename,fileformat,header,overwrite,filesize=4900000000,single=true) %}

    {{ log("Loading data into external blob stage", True) }}

    {%- call statement('query', fetch_result=True,auto_begin=false) -%}

    BEGIN;
    COPY INTO @{{ stage_db_name }}.{{ stage_schema_name }}.{{ stage }}/{{ filename }}
    FROM (SELECT * FROM {{ table_name }})
    FILE_FORMAT = (FORMAT_NAME='{{ target.database }}.{{ stage_schema_name }}.{{ fileformat }}')
    HEADER = {{ header }}
    OVERWRITE = {{ overwrite }}
    MAX_FILE_SIZE= {{ filesize }} 
    SINGLE = {{ single }};
    COMMIT;

    {%- endcall -%}

    {{ log(load_result('query')) }}

    {{ log("Loaded data into external blob stage", True) }}

{% endmacro %}
