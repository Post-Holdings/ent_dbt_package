This [dbt](https://github.com/dbt-labs/dbt) package contains macros that can be (re)used across dbt projects.

## Installation Instructions

Check [dbt Hub](https://hub.getdbt.com/dbt-labs/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

----

## Contents


**[Generic tests](#generic-tests)**

  - 

**[Macros](#macros)**

- [Introspective macros](#introspective-macros):
  - [generate_schema_name](#generate_schema_name)
  - [get_field_definitions](#get_field_definitions)

- [SQL generators](#sql-generators)
  - [check_table_exists](#check_table_exists)
  - [query_comment](#query_comment)
  - [store_test_results](#store_test_results)
  - [truncate_if_exists](#truncate_if_exists)

- [Lookup generators](#lookup-generators)
  - [lkp_exchange_rate_daily_oc](#lkp_exchange_rate_daily_oc)
  - [lkp_exchange_rate_daily](#lkp_exchange_rate_daily)
  - [lkp_exchange_rate_daily_month](#lkp_exchange_rate_daily_month)
  - [lkp_normalization](#lkp_normalization)
  - [lkp_uom](#lkp_uom)

- [test macros](#test-macros)
  - [compare_queries](#compare_queries)
  - [compare_relations](#compare_relations)
  - [test_compare_all_columns](#test_compare_all_columns)
  - [test_compare_column](#test_compare_column)
  - [test_compare_relations](#test_compare_relations)
  - [test_compare_single_column](#test_compare_single_column)
  
----

### Macros

#### lkp_exchange_rate_daily_oc ([source](macros/phi/lkp_exchange_rate_daily_oc.sql))

Returns daily exchange rate for a particular division.

**Usage:**

```yaml
{{ lkp_exchange_rate_daily(CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D,ALIAS) }}
```

#### lkp_exchange_rate_daily ([source](macros/phi/lkp_exchange_rate_daily.sql))

Returns coroporate daily exchange rate.

**Usage:**

```yaml
{{ lkp_exchange_rate_daily_oc(SOURCE_SYSTEM,CURR_FROM_CODE,CURR_TO_CODE,EFF_FROM_D,ALIAS) }}
```

#### lkp_exchange_rate_month ([source](macros/phi/lkp_exchange_rate_month.sql))

Returns monthly exchange rate.

**Usage:**

```yaml
{{ lkp_exchange_rate_month(FROM_CURRENCY_CODE ,TO_CURRENCY_CODE,FISCAL_YEAR_PERIOD_NO,EXCH_RATE_TYPE,ALIAS) }}
```

#### lkp_normalization ([source](macros/phi/lkp_normalization.sql))

Returns normalized value for a given source value.

**Usage:**

```yaml
{{ lkp_normalization('SRC.SOURCE_SYSTEM','FINANCE','DOCUMENT_TYPE_CODE','UPPER(SRC.DOCUMENT_TYPE)','DOCUMENT_TYPE_LKP') }}
```

#### lkp_uom ([source](macros/phi/lkp_uom.sql))

Returns normalized value for a given source value.

**Usage:**

```yaml
{{ lkp_uom(ITEM_GUID,FROM_UOM,TO_UOM,ALIAS) }}
```

----

### Getting started with dbt

- [What is dbt](https://docs.getdbt.com/docs/introduction)?
- Read the [dbt viewpoint](https://docs.getdbt.com/docs/about/viewpoint)
- [Installation](https://docs.getdbt.com/docs/get-started/getting-started/overview)
- Join the [chat](https://www.getdbt.com/community/) on Slack for live questions and support.

## Code of Conduct

Everyone interacting in the dbt project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [PyPA Code of Conduct](https://www.pypa.io/en/latest/code-of-conduct/).
