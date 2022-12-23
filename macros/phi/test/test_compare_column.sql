{%- set columns_to_compare=adapter.get_columns_in_relation(ref('zz_dim_sample'))  -%}

{{ columns_to_compare }}

{% if execute %}
    {% for column in columns_to_compare %}
        {{ log('Comparing column "' ~ column.name ~'"', info=True) }}
        
        {{ column.name }}

    {% endfor %}
{% endif %}