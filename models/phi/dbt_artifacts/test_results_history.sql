{{
    config(
        materialized='incremental',
        transient=false,
        tags=["artifacts", "dbt", "test"],
        schema=env_var("DBT_TEST_SCHEMA"),
        on_schema_change="sync_all_columns"            
    )
}}
with dummy_cte as (
    select 1 as foo
)

select
cast(	null	as 	VARCHAR(16777216)	) as 	INVOCATION_ID	,
cast(	null	as 	VARCHAR(16777216)	) as 	NODE_ID	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_NAME_LONG	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_TYPE	,
cast(	null	as 	VARCHAR(16777216)	) as 	MODEL_REFS	,
cast(	null	as 	VARCHAR(16777216)	) as 	SOURCE_REFS	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_SEVERITY_CONFIG	,
cast(	null	as 	VARCHAR(16777216)	) as 	EXECUTION_TIME_SECONDS	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_RESULT	,
cast(	null	as 	VARCHAR(16777216)	) as 	FILE_TEST_DEFINED	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_TABLE_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_A_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_B_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_A_COUNT	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_B_COUNT	,
cast(	null	as 	VARCHAR(16777216)	) as 	COUNT_DIFF	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_1_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_A_COL_1_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_B_COL_1_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_1_DIFF	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_2_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_A_COL_2_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_B_COL_2_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_2_DIFF	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_3_NAME	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_A_COL_3_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	TABLE_B_COL_3_VALUE	,
cast(	null	as 	VARCHAR(16777216)	) as 	COL_3_DIFF	,
cast(	null	as 	VARCHAR(16777216)	) as 	TEST_STATUS	,
cast(	null	as 	VARCHAR(16777216)	) as 	VARIANCE_PCT_THRESHOLD	,
cast(	null	as 	TIMESTAMP_LTZ(9)	) as 	_TIMESTAMP	
from dummy_cte
where 1 = 0
