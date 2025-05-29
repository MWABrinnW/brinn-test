{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{%- set instance = 'commonwealth' -%}

{{ black_diamond_nml_accounts_lambda(instance=instance, is_historical=true, where_conditions="and a.effective_date <= '2023-09-30'") }}
{# orion integrated 2023-10-01 #}
