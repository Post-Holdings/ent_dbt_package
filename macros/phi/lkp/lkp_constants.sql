{%- macro lkp_constants(field) -%}
{%- set KG_LB_CONVERSION_RATE = 2.204622 -%}
{%- set LB_KG_CONVERSION_RATE = 0.453592 -%}
{%- set CW_LB_CONVERSION_RATE = 100 -%}
{%- set LB_CW_CONVERSION_RATE = 0.01 -%}
{%- set CW_KG_CONVERSION_RATE = 45.3592 -%}
{%- set KG_CW_CONVERSION_RATE = 0.02204622 -%}
{%- set DEFAULT_CONVERSION_RATE = 1 -%}

{%- if   field == "KG_LB_CONVERSION_RATE" -%}   {{ KG_LB_CONVERSION_RATE }}
{%- elif field == "LB_KG_CONVERSION_RATE" -%}   {{ LB_KG_CONVERSION_RATE }}
{%- elif field == "CW_LB_CONVERSION_RATE" -%}   {{ CW_LB_CONVERSION_RATE }}
{%- elif field == "LB_CW_CONVERSION_RATE" -%}   {{ LB_CW_CONVERSION_RATE }}
{%- elif field == "CW_KG_CONVERSION_RATE" -%}   {{ CW_KG_CONVERSION_RATE }}
{%- elif field == "KG_CW_CONVERSION_RATE" -%}   {{ KG_CW_CONVERSION_RATE }}
{%- elif field == "DEFAULT_CONVERSION_RATE" -%} {{ DEFAULT_CONVERSION_RATE }}
{%- endif -%}

{% endmacro %}
