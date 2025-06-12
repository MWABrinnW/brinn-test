{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'system_key']
) }}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = cvar('lookback') -%}

{%-
    set src_models = [
          'portfoliocenter_tcea_history__base_holdings'
    ]
-%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, system_key, max(_created_at) as _created_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
    order by 1
    {% else -%}
    select null::date as effective_date, null::text as system_key
        , null::timestamp as _created_at
    {% endif -%}
)

, source_summary as (
    {%- for src_model in src_models %}
    select
        effective_date              as effective_date
        , system_key                as system_key
        , max(_source_loaded_at)    as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ ref(src_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        -- Holdings actual start date.
        and effective_date >= '2025-01-01'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all

    {%- if not loop.last %}

    union all

    {% endif -%}
    {%- endfor %}
)

, date_spine as (
    select effective_date, system_key from source_summary group by all
    union
    select effective_date, system_key from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.system_key = s.system_key
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.system_key = d.system_key
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

--------------------------------------------------------------------------------------

select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                  as effective_date
    , system_name::text(500)              as system_name
    , system_instance::text(500)          as system_instance
    , system_key::text(500)               as system_key
    , firm_source::text(500)              as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , hiddenportfolioid::text(500)        as account_id
    , account_number_formatted::text(500) as account_number_formatted
    , account_number::text(500)           as account_number
    , household_code::text(500)           as client_id
    , null::text(500)                     as client_name
    , null::text(500)                     as custodian
    , cusip::text(500)                    as cusip
    , symbol::text(500)                   as ticker
    , null::int                           as is_ticker_cusip
    , null::int                           as is_custodial_cash
    , null::text(500)                     as security_id
    , security_description::text(500)     as security_name
    , security_type::text(500)            as security_type
    , null::text(500)                     as security_subtype
    , asset_class_description::text(500)  as asset_class
    , market_value::number(19 , 9)        as market_value
    , quantity::number(19 , 9)            as quantity
    , current_price::number(19 , 9)       as price
    , null::number(19 , 9)                as price_unfactored
    , null::number(19 , 9)                as factor
    , cost_basis::number(19 , 9)          as cost_basis
    , 0::int                              as is_legacy
    , 0::int                              as is_manual_holdings
    --- [meta] ----------------------------------------------------------------------
    , current_timestamp()::datetime       as _created_at
    , _source_loaded_at::datetime         as _source_loaded_at
    , null::text(500)                     as _source_file
from {{ ref('portfoliocenter_tcea_history__base_holdings') }}
where 1 = 1
    and exists(select 1 from dates_to_refresh)
    and effective_date in (select distinct t.effective_date from dates_to_refresh as t)
