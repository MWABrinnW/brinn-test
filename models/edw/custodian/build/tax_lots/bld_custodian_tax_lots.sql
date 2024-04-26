{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
)}}

{# Set the upstream raw models here and dbt will use them dynamically below.
   We want to use these because when we check for new data they are more performant
   than referencing the temporary nml models.
#}
{%-
    set source_models = [
          'schwab__base_tax_lots'
         ,'fidelity_baystate_history__vw_tlaopen_tax_accounting'
         ,'fidelity_mps_history__vw_tlaopen_tax_accounting'
         ,'fidelity_swag_history__vw_tlaopen_tax_accounting'
         ,'fidelity_mwa_history__vw_tlaopen_tax_accounting'
    ]
-%}


{# Set the upstream normalized models here that feed the build. #}
{%-
    set nml_models = [
          'nml_schwab_tax_lots'
         ,'nml_fidelity_mps_tax_lots'
         ,'nml_fidelity_swag_tax_lots'
         ,'nml_fidelity_baystate_tax_lots'
         ,'nml_fidelity_mwa_tax_lots'
    ]
-%}

with cte_destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        and effective_date >= (current_date() - {{ var('lookback_custodial', 30) }})
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = '1=1'
        ) }}
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

-- Here we interrogate the source data to determine if there is new data
-- that should be considered for the incremental.
, cte_fresh_sources as (
    {% for src_model in source_models -%}
    select a.custodian, a.firm_source, a.effective_date, {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }} a
    left join cte_destination_summary b
        on a.effective_date = b.effective_date
        and a.custodian = b.custodian
        and a.firm_source = b.firm_source
    where 1=1
        and a.effective_date >= (current_date() - {{ var('lookback_custodial', 30) }})
        {{ incremental_date_filter(
            source_col_name='a.effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = '1=1'
        ) }}
        and b.effective_date is null
        and a.firm_source in ('mwa', 'mps', 'swag', 'network', 'baystate')
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {% endfor %}
)

, cte_dates_to_refresh as (
    select distinct effective_date from cte_fresh_sources
)

-- Grab new data for any effective dates determined to be "fresh".
, cte_data_to_refresh as (
    {% for nml_model in nml_models -%}
    select *
    from {{ ref(nml_model) }}
    where 1 = (select case when (select count(*) from cte_fresh_sources) > 0 then 1 else 0 end)
        {{ incremental_date_filter(
            source_col_name='effective_date',
            target_col_name='effective_date',
            do_lookback = false,
            do_new = false,
            custom_condition_only = true,
            custom_condition = 'effective_date in (select effective_date from cte_dates_to_refresh)'
        ) }}

    {%- if not loop.last %}

    union all

    {% endif -%}
    {% endfor %}
)

select *
    , dense_rank() over(
        partition by effective_date, custodian, account_number
        order by
            {{ firm_source_rank() }})::int as rn_global
    , current_timestamp() as _created_at
from cte_data_to_refresh
