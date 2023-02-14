{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}
{# full_refresh=true if flags.FULL_REFRESH and var('full_refresh_force', false) else false #}

with cte_max_created_at as
(
    select max(_created_at) as _created_at from {{ this }}
)
,cte_effective_dates_out_of_date as
(
  select distinct effective_date
  from {{ ref('nml_schwab_mwa_accounts') }}
  where _source_loaded_at > (select max(_created_at) from cte_max_created_at)

  union

  select distinct effective_date
  from {{ ref('nml_schwab_mps_accounts') }}
  where _source_loaded_at > (select max(_created_at) from cte_max_created_at)

  union

  select distinct effective_date
  from {{ ref('nml_fidelity_mwa_accounts') }}
  where _created_at > (select max(_created_at) from cte_max_created_at)

  union

  select distinct effective_date
  from {{ ref('nml_fidelity_mps_accounts') }}
  where _created_at > (select max(_created_at) from cte_max_created_at)

  union

  select distinct effective_date
  from {{ ref('nml_lpl_network_accounts') }}
  where _source_loaded_at > (select max(_created_at) from cte_max_created_at)
)
,cte_accounts as
(
    /* SCHWAB */
    select *
    from {{ ref('nml_schwab_mwa_accounts') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            filter="and lower(custodian) = 'schwab' and lower(firm) = 'mwa'",
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

    union all

    select *
    from {{ ref('nml_schwab_mps_accounts') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            filter="and lower(custodian) = 'schwab' and lower(firm) = 'mps'",
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

    union all

    /* FIDELITY */
    select * exclude _created_at
    from {{ ref('nml_fidelity_mwa_accounts') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            filter="and lower(custodian) = 'fidelity' and lower(firm) = 'mwa'",
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

    union all

    select * exclude _created_at
    from {{ ref('nml_fidelity_mps_accounts') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            filter="and lower(custodian) = 'fidelity' and lower(firm) = 'mps'",
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

    {# union all #}

    /* TDA */
    {# select *
    from {{ ref('nml_tda_mwa_accounts') }}
    where true
        {{ incremental_date_filter(source_col_name='effective_date', target_col_name='effective_date', filter="and lower(custodian) = 'tda' and lower(firm) = 'mwa'") }} #}

    /* PERSHING */

    /* LPL */
    union all

    select * 
    from {{ ref('nml_lpl_network_accounts') }}
    where true
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            filter="and lower(custodian) = 'fidelity' and lower(firm) = 'mps'",
            custom_condition = 'effective_date in (select distinct effective_date from cte_effective_dates_out_of_date)'
        ) }}

)

select *, current_timestamp()::timestamp as _created_at
from cte_accounts
