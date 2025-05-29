{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'custodian']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

{# Set the upstream normalized models here and dbt will use them dynamically below #}
{%-
    set source_models = [
          'nml_fidelity_mps_cash'
         ,'nml_fidelity_mwa_cash'
         ,'nml_fidelity_swag_cash'
         ,'nml_fidelity_baystate_cash'
         ,'nml_schwab_mps_cash'
         ,'nml_schwab_mwa_cash'
         ,'nml_schwab_swag_cash'
         ,'nml_pershing_mwa_cash'
         ,'nml_pershing_mps_cash'
         ,'nml_tda_mwa_cash'
         ,'nml_tda_mps_cash'
         ,'nml_tda_swag_cash'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, firm_source, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by 1,2,3
    order by 1,2,3
    {% else -%}
    select null::date as effective_date, null::text as custodian, null::text as firm_source
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {% for nml_model in source_models -%}
    select effective_date, custodian, firm_source, max(_source_loaded_at) as _created_at, {{"'" ~ nml_model ~ "'"}} as model_source
    from {{ ref(nml_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, custodian, firm_source from source_summary group by all
    union
    select effective_date, custodian, firm_source from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date
        , a.custodian
        , a.firm_source
        , s._created_at as source_created_at
        , d._created_at as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
        and a.firm_source = s.firm_source
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
        and a.firm_source = d.firm_source
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

, cte_cash as (
    {% for nml_model in source_models -%}
    select
        effective_date             as effective_date
        , custodian                as custodian
        , firm                     as firm
        , firm_source              as firm_source
        , account_number           as account_number
        , account_number_formatted as account_number_formatted
        , total_cash_value         as total_cash_value
        , money_market_value       as money_market_value
        , option_market_value      as option_market_value
        , margin_equity_value      as margin_equity_value
        , is_head                  as is_head
        , _source_file             as _source_file
        , _source_loaded_at        as _source_loaded_at
        , row_number() over (
            partition by effective_date, custodian, account_number order by firm_source
            )                      as rn_firm_source
    from {{ ref(nml_model) }}
    where true
        and effective_date in (select distinct effective_date from dates_to_refresh)

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

select *
    , row_number() over(partition by effective_date, custodian, account_number
                    order by {{ firm_source_rank() }}
                    )                as rn_global
    , current_timestamp()::timestamp as _created_at
from cte_cash
where rn_firm_source = 1
