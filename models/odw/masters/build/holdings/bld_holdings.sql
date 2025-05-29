--this model does not include orion records. those records are joined in a downstream model.
{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'system_key']
) }}

{%- set start_date = cvar('start_date_pms') -%}
{%- set lookback = cvar('lookback') -%}

{%- set source_models = [
    'nml_addepar_corbenic_holdings',
    'nml_axys_granite_holdings',
    'nml_black_diamond_baystate_holdings' ,
    'nml_black_diamond_houston_holdings' ,
    'nml_black_diamond_mps_holdings' ,
    'nml_black_diamond_uhnw_holdings' ,
    'nml_envestnet_manasquan_holdings' ,
    'nml_portfoliocenter_tcea_holdings' ,
    'nml_tamarac_state_college_holdings' ,
    'nml_tpg_hfw_holdings'
] -%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, system_key, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        -- We only need to build starting in 2025.
        and effective_date >= '2025-01-01'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
    order by 1,2
    {% else -%}
    select null::date as effective_date, null::text as system_key
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    {% for nml_model in source_models -%}
    select effective_date, system_key, max(_source_loaded_at) as _created_at, {{"'" ~ nml_model ~ "'"}} as model_source
    from {{ ref(nml_model) }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        -- We only need to build starting in 2025.
        and effective_date >= '2025-01-01'
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
    select effective_date, system_key from source_summary group by all
    union
    select effective_date, system_key from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.system_key      as system_key
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
        , case
            when s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
                then 1
            else 0
            end::int        as is_stale
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.system_key = s.system_key
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.system_key = d.system_key
    where 1 = 1
    group by all
)

, data_to_build as (
    {%- for nml_model in source_models %}
        select
            effective_date                             as effective_date
            , system_name                              as system_name
            , system_instance                          as system_instance
            , system_key                               as system_key
            , firm_source                              as firm_source
            , account_id                               as account_id
            , account_number_formatted                 as account_number_formatted
            , account_number                           as account_number
            , client_id                                as client_id
            , client_name                              as client_name
            , custodian                                as custodian
            , cusip                                    as cusip
            , ticker                                   as ticker
            , is_ticker_cusip                          as is_ticker_cusip
            , is_custodial_cash                        as is_custodial_cash
            , security_id                              as security_id
            , security_name                            as security_name
            , security_type                            as security_type
            , security_subtype                         as security_subtype
            , asset_class                              as asset_class
            , market_value                             as market_value
            , quantity                                 as quantity
            , price                                    as price
            , price_unfactored                         as price_unfactored
            , factor                                   as factor
            , cost_basis                               as cost_basis
            , _source_loaded_at                        as _source_loaded_at
            , _source_file                             as _source_file
            , '{{ nml_model }}'                        as _source_model
            , concat(effective_date, '__', system_key) as _effective_date__system_key
        from {{ ref(nml_model) }}
        where 1 = 1
            -- Offer the snowflake query optimizer a chance to prune the query early
            -- if there are no dates to refresh.
            and exists (select 1 from dates_to_refresh where is_stale = 1)
            and effective_date in (select distinct t.effective_date from dates_to_refresh as t where t.is_stale = 1)
        {%- if not loop.last %}

        union all

        {%- endif %}
    {%- endfor %}
)


select
    *
    , current_timestamp()::datetime as _created_at
from data_to_build
where true
order by effective_date, account_number, market_value
