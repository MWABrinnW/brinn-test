{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}
{# full_refresh=true if flags.FULL_REFRESH and var('full_refresh_force', false) else false #}

/* SCHWAB */
select *
from {{ ref('nml_schwab_mwa_accounts') }}
where true
    {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'schwab' and lower(firm) = 'mwa'") }}

union all

select *
from {{ ref('nml_schwab_mps_accounts') }}
where true
    {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'schwab' and lower(firm) = 'mps'") }}

union all

/* FIDELITY */
select *
from {{ ref('nml_fidelity_mwa_accounts') }}
where true
    {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'fidelity' and lower(firm) = 'mwa'") }}

union all

select *
from {{ ref('nml_fidelity_mps_accounts') }}
where true
    {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'fidelity' and lower(firm) = 'mps'") }}

{# union all #}

/* TDA */
{# select *
from {{ ref('nml_tda_mwa_accounts') }}
where true
    {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'tda' and lower(firm) = 'mwa'") }} #}
