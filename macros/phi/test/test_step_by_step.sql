-- try setting defaults for these
{%- macro test_step_by_step(
    table_a_name,
    table_b_name,
    table_a_col_1,
    table_a_col_2,
    table_a_col_3,
    table_b_col_1,
    table_b_col_2,
    table_b_col_3,
    date_field,
    var_pct_threshold
) -%}

{% set table_a = ref(table_a_name) %}

{% set table_b = ref(table_b_name) %}

with
    table_a as (
        select
            count(*) as table_a_count,
            sum({{ table_a_col_1 }}) as table_a_col_1,
            sum({{ table_a_col_2 }}) as table_a_col_2,
            sum({{ table_a_col_3 }}) as table_a_col_3
        from {{ table_a }}
    ),

    table_b as (
        select
            count(*) as table_b_count,
            sum({{ table_b_col_1 }}) as table_b_col_1,
            sum({{ table_b_col_2 }}) as table_b_col_2,
            sum({{ table_b_col_3 }}) as table_b_col_3
        from {{ table_b }}
        where {{ date_field }} in (select {{ date_field }} from {{ table_a }})
    ),
    final as (
        select
            table_a_count,
            table_b_count,
            (abs(table_a_count - table_b_count) / table_a_count) * 100 as count_diff,
            table_a_col_1,
            table_b_col_1,
            case
                when table_a_col_1 = 0 and table_b_col_1 = 0
                then 0
                else (abs(table_a_col_1 - table_b_col_1) / table_a_col_1) * 100
            end as col_1_diff,
            table_a_col_2,
            table_b_col_2,
            case
                when table_a_col_2 = 0 and table_b_col_2 = 0
                then 0
                else (abs(table_a_col_2 - table_b_col_2) / table_a_col_2) * 100
            end as col_2_diff,
            table_a_col_3,
            table_b_col_3,
            case
                when table_a_col_3 = 0 and table_b_col_3 = 0
                then 0
                else (abs(table_a_col_3 - table_b_col_3) / table_a_col_3) * 100
            end as col_3_diff
        from table_a
        join table_b on 1 = 1
    )
select
    '{{table_a.name}}' as table_a_name,
    '{{table_b.name}}' as table_b_name,
    table_a_count,
    table_b_count,
    count_diff,
    '{{table_a_col_1}}' as col_1_name,
    table_a_col_1 as table_a_col_1_value,
    table_b_col_1 as table_b_col_1_value,
    col_1_diff,
    '{{table_a_col_2}}' as col_2_name,
    table_a_col_2 as table_a_col_2_value,
    table_b_col_2 as table_b_col_2_value,
    '{{table_a_col_2}}' as col_3_name,
    col_2_diff,
    table_a_col_3 as table_a_col_3_value,
    table_b_col_3 as table_b_col_3_value,
    col_3_diff,
    case
        when
            count_diff >{{ var_pct_threshold }}
            or col_1_diff >{{ var_pct_threshold }}
            or col_2_diff > {{ var_pct_threshold }}
            or col_3_diff >{{ var_pct_threshold }}
        then 'warning'
        else 'pass'
    end as test_status,
    '{{ var_pct_threshold }}' as variance_pct_threshold 
from final
/*where
    count_diff >{{ var_pct_threshold }}
    or col_1_diff >{{ var_pct_threshold }}
    or col_2_diff > {{ var_pct_threshold }}
    or col_3_diff >{{ var_pct_threshold }}
*/

{% endmacro %}
