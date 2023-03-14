--try setting defaults here
{%- macro test_time_travel(
    table_name,
    table_col_1,
    table_col_2,
    table_col_3,
    travel_back_days,
    var_pct_threshold
) -%}

{% set fact = ref(table_name) %}

with

    today as (
        select
            count(*) as new_fact_count,
            sum({{ table_col_1 }}) as new_table_col_1,
            sum({{ table_col_2 }}) as new_table_col_2,
            sum({{ table_col_3 }}) as new_table_col_3
        from {{ fact }}
    ),


    time_travel as (
        select
            count(*) as old_fact_count,
            sum({{ table_col_1 }}) as old_table_col_1,
            sum({{ table_col_2 }}) as old_table_col_2,
            sum({{ table_col_3 }}) as old_table_col_3
        from {{ fact }} at(offset => -3600 * 24 *{{ travel_back_days }})
    ),

    final as (
        select
            old_fact_count,
            new_fact_count,
            (abs(old_fact_count - new_fact_count) / old_fact_count) * 100 as count_diff,
            old_table_col_1,
            new_table_col_1,
            case
                when old_table_col_1 = 0 and new_table_col_1 = 0
                then 0
                else (abs(old_table_col_1 - new_table_col_1) / old_table_col_1) * 100
            end as amt_1_diff,
            old_table_col_2,
            new_table_col_2,
            case
                when old_table_col_2 = 0 and new_table_col_2 = 0
                then 0
                else (abs(old_table_col_2 - new_table_col_2) / old_table_col_2) * 100
            end as amt_2_diff,
            old_table_col_3,
            new_table_col_3,
            case
                when old_table_col_3 = 0 and new_table_col_3 = 0
                then 0
                else (abs(old_table_col_3 - new_table_col_3) / old_table_col_3) * 100
            end as amt_3_diff
        from today
        join time_travel on 1 = 1
    )

select
    '{{ fact }} - {{ travel_back_days }} days' as table_a_name,
    '{{ fact }}' as table_b_name,
    old_fact_count as table_a_count,
    new_fact_count as table_b_count,
    count_diff as count_diff,
    '{{table_col_1}}' as col_1_name,
    old_table_col_1 as table_a_value_1,
    new_table_col_1 as table_b_value_1,
    amt_1_diff as col_1_diff,
    '{{table_col_2}}' as col_2_name,
    old_table_col_2 as table_a_value_2,
    new_table_col_2 as table_b_value_2,
    amt_2_diff as col_2_diff,
    '{{table_col_3}}' as col_3_name,
    old_table_col_3 as table_a_value_3,
    new_table_col_3 as table_b_value_3,
    amt_3_diff as col_3_diff,
    case
        when
            count_diff >{{ var_pct_threshold }}
            or amt_1_diff >{{ var_pct_threshold }}
            or amt_2_diff > {{ var_pct_threshold }}
            or amt_3_diff >{{ var_pct_threshold }}
        then 'warning'
        else 'pass'
    end as test_status,
    '{{ var_pct_threshold }}' as variance_pct_threshold 
from final
/* where
            count_diff >{{ var_pct_threshold }}
            or amt_1_diff >{{ var_pct_threshold }}
            or amt_2_diff > {{ var_pct_threshold }}
            or amt_3_diff >{{ var_pct_threshold }}
*/
{% endmacro %}
