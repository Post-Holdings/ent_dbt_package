{% macro remove_blob(stage_db_name,stage_schema_name,stage,path,pattern) %}

    {{ log("Removing blob", True) }}
    BEGIN;
    RM @{{ stage_db_name }}.{{ stage_schema_name }}.{{ stage }}{{ path }}
    PATTERN='{{ pattern }}';
    COMMIT;
    {{ log("Removed blob", True) }}

{% endmacro %}
