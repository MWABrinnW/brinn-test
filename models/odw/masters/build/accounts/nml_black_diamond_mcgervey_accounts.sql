{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
) }}

{%- set instance = 'mcgervey' -%}

{{ black_diamond_nml_accounts_lambda(instance=instance, is_historical=true, where_conditions="and a.effective_date <= '2023-03-31'") }}
{# orion integrated 2023-04-01 #}
