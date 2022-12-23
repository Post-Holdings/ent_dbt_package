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

, model_executions as (

  select *
  from {{ ref('fct_dbt__model_executions') }}
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, tests as (

  select *
  , array_to_string((depends_on_nodes), ', ') as depends_on_node_id
  from {{ ref('dim_dbt__tests') }}
  , table(flatten(depends_on_nodes))
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

, test_executions as (

  select *
  from {{ ref('fct_dbt__test_executions') }}
  where run_started_at >= dateadd(mm, -3, date_trunc('month', current_date()))  --- 1st day of 3 months before today

)

select 
models.model_execution_id as model_execution_id,
models.command_invocation_id as model_command_invocation_id,
models.node_id as model_node_id,
models.run_started_at as model_run_started_at,
models.database as model_database,
models.schema as model_schema,
models.name as model_name,
models.depends_on_nodes as model_dependent_nodes,
models.package_name as model_package_name,
models.path as model_path,
models.materialization as model_materialization,

--model_executions.model_execution_id,
--model_executions.command_invocation_id,
model_executions.node_id as executed_model_node_id,
model_executions.run_started_at as executed_model_run_started_at,
model_executions.was_full_refresh as executed_model_was_full_refresh,
model_executions.thread_id as executed_model_thread_id,
model_executions.status as executed_model_status,
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
tests.depends_on_nodes as test_depends_on_nodes,
tests.depends_on_node_id as test_depends_on_node_id,
tests.package_name as test_package_name,
tests.test_path as test_test_path,
tests.tags as test_tags,

test_executions.test_execution_id as executed_test_execution_id,
--test_executions.command_invocation_id,
test_executions.node_id as executed_test_node_id,
test_executions.run_started_at as executed_test_run_started_at,
test_executions.was_full_refresh as executed_test_was_full_refresh,
test_executions.thread_id as executed_test_thread_id,
test_executions.status as executed_test_status,
test_executions.compile_started_at as executed_test_compile_started_at,
test_executions.query_completed_at as executed_test_query_completed_at,
test_executions.total_node_runtime as executed_test_total_node_runtime,
test_executions.rows_affected as executed_test_rows_affected,
test_executions.failures as executed_test_failures

from models
left join model_executions
on model_executions.node_id = models.node_id
and model_executions.command_invocation_id = models.command_invocation_id
left join tests
on tests.command_invocation_id = models.command_invocation_id
and tests.depends_on_node_id = models.node_id
left join test_executions
on test_executions.node_id = tests.node_id
and test_executions.command_invocation_id = tests.command_invocation_id