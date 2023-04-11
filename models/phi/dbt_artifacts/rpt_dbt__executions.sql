{{
  config(
    materialized=env_var('DBT_MAT_VIEW'),
    on_schema_change='sync_all_columns',
    enabled=true
  )
}}

with models as (

  select *
  from {{ ref('dim_dbt__models') }} 
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, model_tags as (

  select distinct a.*
  , replace(f.value,'"','') as model_tags
  from {{ ref('dim_dbt__models') }} a
  , table(flatten(tags)) f
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, model_dependent_nodes as (

  select distinct a.*
  , replace(f.value,'"','') as model_dependent_nodes
  from {{ ref('dim_dbt__models') }} a
  , table(flatten(depends_on_nodes)) f
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, model_executions as (

  select *
  from {{ ref('fct_dbt__model_executions') }}
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, tests as (

  select *
  --, array_to_string((depends_on_nodes), ', ') as depends_on_node_id
  , replace(f.value,'"','') as depends_on_node_id
  from {{ ref('dim_dbt__tests') }}
  , table(flatten(depends_on_nodes)) f
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, test_tags as (

  select distinct a.*
  , replace(f.value,'"','') as test_tags
  from {{ ref('dim_dbt__tests') }} a
  , table(flatten(tags)) f
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)
, test_executions as (

  select *
  from {{ ref('fct_dbt__test_executions') }}
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)
/*
, tests_stats as (
  select test_name,
  to_date(snapshot_date) as snapshot_date,
  failure_count,
  dbt_scd_id,
  dbt_updated_at,
  dbt_valid_from,
  dbt_valid_to
  from {{ ref('src_dbt_tests_snapshots') }}
  where snapshot_date >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today
)
*/
, tests_dq_stats as (
  select 
    invocation_id	,
    node_id	,
    test_name	,
    test_name_long	,
    test_type	,
    model_refs	,
    source_refs	,
    test_severity_config	,
    execution_time_seconds	,
    test_result	,
    file_test_defined	,
    test_table_name	,
    table_a_name	,
    table_b_name	,
    table_a_count	,
    table_b_count	,
    count_diff	,
    col_1_name	,
    table_a_col_1_value	,
    table_b_col_1_value	,
    col_1_diff	,
    col_2_name	,
    table_a_col_2_value	,
    table_b_col_2_value	,
    col_2_diff	,
    col_3_name	,
    table_a_col_3_value	,
    table_b_col_3_value	,
    col_3_diff	,
    test_status	,
    variance_pct_threshold	,
    _timestamp	
  from {{ ref('src_test_results_history') }}
  where _timestamp >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today
)
, sla as (
  select 'ENT' as oc, '420' as sla_minutes  -- 7 am
  UNION
  select 'BEF' as oc, '330 ' as sla_minutes  -- 5.30 am
  UNION
  select 'E8AVE' as oc, '390' as sla_minutes  -- 6.30 am
  UNION
  select 'WBX' as oc, '0 ' as sla_minutes  -- 12 am
  UNION
  select 'BRBR' as oc, '420 ' as sla_minutes  -- 7 am
  UNION
  select 'PCB' as oc, '420' as sla_minutes  -- 7 am
  UNION
  select 'MFI' as oc, '420' as sla_minutes  -- 7 am
)
, invocations as (
  select 
    command_invocation_id,
    dbt_version,
    project_name,
    run_started_at,
    dbt_command,
    full_refresh_flag,
    target_profile_name,
    target_name,
    target_schema,
    target_threads,
    dbt_cloud_project_id,
    dbt_cloud_job_id,
    dbt_cloud_run_id,
    dbt_cloud_run_reason_category,
    dbt_cloud_run_reason,
    env_vars,
    dbt_vars,
    'https://cloud.getdbt.com/deploy/60665/projects/' || dbt_cloud_project_id || '/jobs/' || dbt_cloud_job_id as dbt_cloud_job_url,
    'https://cloud.getdbt.com/deploy/60665/projects/' || dbt_cloud_project_id || '/runs/' || dbt_cloud_run_id as dbt_cloud_run_url
  from {{ ref('fct_dbt__invocations') }}
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today
)

select 
invocations.project_name as project_name,
invocations.dbt_version as dbt_version,
invocations.dbt_cloud_project_id as dbt_cloud_project_id,
invocations.dbt_cloud_job_id as dbt_cloud_job_id,
invocations.dbt_cloud_run_id as dbt_cloud_run_id,
invocations.dbt_cloud_run_reason as dbt_cloud_run_reason,
invocations.dbt_cloud_job_url as dbt_cloud_job_url,
invocations.dbt_cloud_run_url as dbt_cloud_run_url,
models.model_execution_id as model_execution_id,
models.command_invocation_id as model_command_invocation_id,
models.node_id as model_node_id,
models.run_started_at as model_run_started_at,
models.database as model_database,
models.schema as model_schema,
models.name as model_name,
--models.depends_on_nodes as model_dependent_nodes,
model_dependent_nodes.model_dependent_nodes as model_dependent_nodes,
models.package_name as model_package_name,
models.path as model_path,
models.materialization as model_materialization,
model_tags.model_tags as model_tags,

--model_executions.model_execution_id,
--model_executions.command_invocation_id,
model_executions.node_id as executed_model_node_id,
model_executions.run_started_at as executed_model_run_started_at,
model_executions.was_full_refresh as executed_model_was_full_refresh,
model_executions.thread_id as executed_model_thread_id,
case when model_executions.status is null then 'did not run'
     else model_executions.status end as executed_model_status,
model_executions.compile_started_at as executed_model_compile_started_at,
model_executions.query_completed_at as executed_model_query_completed_at,
model_executions.total_node_runtime as executed_model_runtime_seconds,
model_executions.rows_affected as executed_model_rows_affected,
model_executions.materialization as executed_model_materialization,
model_executions.schema as executed_model_schema,
model_executions.name as executed_model_name,

tests.test_execution_id,
--tests.command_invocation_id,
tests.node_id as test_node_id,
tests.run_started_at as test_run_started_at,
tests.name as test_name,
--tests.depends_on_nodes as test_depends_on_nodes,
tests.depends_on_node_id as test_depends_on_node_id,
tests.package_name as test_package_name,
tests.test_path as test_test_path,
test_tags.test_tags as test_tags,

test_executions.test_execution_id as executed_test_execution_id,
--test_executions.command_invocation_id,
test_executions.node_id as executed_test_node_id,
test_executions.run_started_at as executed_test_run_started_at,
test_executions.was_full_refresh as executed_test_was_full_refresh,
test_executions.thread_id as executed_test_thread_id,
case when test_executions.status is null then 'did not run'
     else test_executions.status end as executed_test_status,
to_timestamp_tz(convert_timezone('UTC','America/Chicago',to_timestamp_ntz(test_executions.compile_started_at))) as executed_test_compile_started_at,
to_timestamp_tz(convert_timezone('UTC','America/Chicago',to_timestamp_ntz(test_executions.query_completed_at))) as executed_test_query_completed_at,
test_executions.total_node_runtime as executed_test_total_node_runtime,
test_executions.rows_affected as executed_test_rows_affected,
test_executions.failures as executed_test_failures,

/*
to_date(tests_stats.snapshot_date) as snapshot_date,
tests_stats.failure_count as test_failure_count,
tests_stats.dbt_scd_id,
tests_stats.dbt_updated_at,
tests_stats.dbt_valid_from,
tests_stats.dbt_valid_to,
*/
tests_dq_stats.model_refs 	as	test_model_refs 	,
tests_dq_stats.test_result	as	test_result	,
tests_dq_stats.file_test_defined	as	test_file_test_defined	,
tests_dq_stats.test_table_name	as	test_table_name	,
tests_dq_stats.table_a_name	as	test_table_a_name	,
tests_dq_stats.table_b_name	as	test_table_b_name	,
tests_dq_stats.table_a_count	as	test_table_a_count	,
tests_dq_stats.table_b_count	as	test_table_b_count	,
tests_dq_stats.count_diff	as	test_count_diff	,
tests_dq_stats.col_1_name	as	test_col_1_name	,
tests_dq_stats.table_a_col_1_value	as	test_table_a_col_1_value	,
tests_dq_stats.table_b_col_1_value	as	test_table_b_col_1_value	,
tests_dq_stats.col_1_diff	as	test_col_1_diff	,
tests_dq_stats.col_2_name	as	test_col_2_name	,
tests_dq_stats.table_a_col_2_value	as	test_table_a_col_2_value	,
tests_dq_stats.table_b_col_2_value	as	test_table_b_col_2_value	,
tests_dq_stats.col_2_diff	as	test_col_2_diff	,
tests_dq_stats.col_3_name	as	test_col_3_name	,
tests_dq_stats.table_a_col_3_value	as	test_table_a_col_3_value	,
tests_dq_stats.table_b_col_3_value	as	test_table_b_col_3_value	,
tests_dq_stats.col_3_diff	as	test_col_3_diff	,
tests_dq_stats.test_status	as	test_status	,
tests_dq_stats.variance_pct_threshold	as	test_variance_pct_threshold	,
case when date_part(minutes,model_run_started_at) >= 12 then dateadd(minutes,sla.sla_minutes,dateadd(day,1,date_trunc('day',model_run_started_at)))
     else dateadd(minutes,sla.sla_minutes,date_trunc('day',model_run_started_at)) end as sla,
case when model_executions.query_completed_at > sla then 'sla-missed' else 'sla-met' end sla_status

from models
left join model_executions
on model_executions.node_id = models.node_id
and model_executions.command_invocation_id = models.command_invocation_id
left join tests
on tests.command_invocation_id = models.command_invocation_id
and tests.depends_on_node_id = models.node_id
--and tests.depends_on_node_id like concat('%',models.node_id,'%')
left join test_executions
on test_executions.node_id = tests.node_id
and test_executions.command_invocation_id = tests.command_invocation_id
/*
left join tests_stats
on upper(tests_stats.test_name) = upper(tests.name)
--and tests_stats.snapshot_date = to_date(test_executions.query_completed_at)
and dbt_valid_from between to_timestamp_tz(convert_timezone('UTC','America/Chicago',to_timestamp_ntz(test_executions.compile_started_at))) and to_timestamp_tz(convert_timezone('UTC','America/Chicago',to_timestamp_ntz(test_executions.query_completed_at)))
*/
left join tests_dq_stats
on tests_dq_stats.node_id = tests.node_id
and tests_dq_stats.invocation_id = tests.command_invocation_id
and upper(tests_dq_stats.test_name) = upper(tests.name)
left join model_tags
on model_tags.node_id = models.node_id
and model_tags.command_invocation_id = models.command_invocation_id
left join test_tags
on test_tags.node_id = tests.node_id
and test_tags.command_invocation_id = tests.command_invocation_id
left join model_dependent_nodes
on model_dependent_nodes.node_id = models.node_id
and model_dependent_nodes.command_invocation_id = models.command_invocation_id
left join sla
on sla.oc = upper(substr(models.database,0,regexp_instr(models.database,'_') - 1))
left join invocations
on invocations.command_invocation_id = models.command_invocation_id
