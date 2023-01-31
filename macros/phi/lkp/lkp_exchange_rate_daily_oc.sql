{%- macro lkp_exchange_rate_daily_oc(SOURCE_SYSTEM,CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D,ALIAS) -%}
(SELECT SOURCE_SYSTEM,CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D,CURR_CONV_RT,
ROW_NUMBER() over (partition by SOURCE_SYSTEM,CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D order by CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D ) AS ROW_NUM
    FROM ( {{ ref('src_currency_exch_rate_dly_dim_oc')}} ) ) {{ALIAS}}
    ON {{ALIAS}}.SOURCE_SYSTEM = {{ SOURCE_SYSTEM }}	
    AND {{ALIAS}}.CURR_FROM_CODE = {{ CURR_FROM_CODE }}
    AND {{ALIAS}}.CURR_TO_CODE = {{ CURR_TO_CODE }}
    AND {{ALIAS}}.EFF_FROM_D = {{ EFF_FROM_D }}
    AND {{ALIAS}}.ROW_NUM =1
{% endmacro %}