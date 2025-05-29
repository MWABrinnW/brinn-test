{{config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date']
)}}

{%- set start_date = cvar('start_date_custodian') -%}
{%- set lookback = cvar('lookback') -%}

with destination_summary as (
    {% if is_incremental() -%}
    select effective_date, custodian, max(_created_at) as _created_at, max(_source_loaded_at) as _source_loaded_at
    from {{ this }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
    order by 1,2
    {% else -%}
    select null::date as effective_date, null::text as custodian
        , null::timestamp as _created_at, null::timestamp as _source_loaded_at
    {% endif -%}
)

, source_summary as (
    select
        effective_date              as effective_date
        , custodian                 as custodian
        , max(_source_loaded_at)    as _created_at
        , {{"'" ~ src_model ~ "'"}} as model_source
    from {{ source('schwab', 'rps_cash') }}
    where 1 = 1
        -- Model start date. This applies for full-refresh.
        and effective_date >= '{{ start_date }}'
        {%- if is_incremental() or target.name not in ['prod'] %}
        -- Restrict lookback window if incremental or not prod.
        and effective_date >= current_date() - {{ lookback }}
        {%- endif %}
    group by all
)

, date_spine as (
    select effective_date, custodian from source_summary group by all
    union
    select effective_date, custodian from destination_summary group by all
)

, dates_to_refresh as (
    select
        a.effective_date    as effective_date
        , a.custodian       as custodian
        , s._created_at     as source_created_at
        , d._created_at     as destination_created_at
    from date_spine a
    left join source_summary s
        on a.effective_date = s.effective_date
        and a.custodian = s.custodian
    left join destination_summary d
        on a.effective_date = d.effective_date
        and a.custodian = d.custodian
    where 1 = 1
        and (
            -- Check if missing from destination OR the source records are newer for that date.
            s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
        )
    group by all
)

select
    a.custodian                                               as custodian
    , cl.firm_source                                          as firm_source
    , cf.firm                                                 as firm
    , a.record_type                                           as record_type
    , a.custodian_id                                          as custodian_id
    , a.master_account_number                                 as master_account_number
    , a.master_account_name                                   as master_account_name
    , a.business_date                                         as business_date
    , a.account_number                                        as account_number
    , a.account_title_line_1                                  as account_title_line_1
    , a.account_title_line_2                                  as account_title_line_2
    , a.account_title_line_3                                  as account_title_line_3
    , a.account_registration                                  as account_registration
    , a.account_type                                          as account_type
    , a.net_credit_or_debit_settled_unsettled                 as net_credit_or_debit_settled_unsettled
    , a.margin_balance_settled_unsettled                      as margin_balance_settled_unsettled
    , a.total_available_to_pay                                as total_available_to_pay
    , a.margin_buying_power                                   as margin_buying_power
    , a.money_market_funds_settled_unsettled                  as money_market_funds_settled_unsettled
    , a.mtd_margin_interest                                   as mtd_margin_interest
    , a.daily_margin_interest                                 as daily_margin_interest
    , a.equity_excluding_options                              as equity_excluding_options
    , a.equity_percentage                                     as equity_percentage
    , a.market_value_long                                     as market_value_long
    , a.market_value_short                                    as market_value_short
    , a.equity_including_options                              as equity_including_options
    , a.option_requirements                                   as option_requirements
    , a.month_end_dividend_payout                             as month_end_dividend_payout
    , a.maintenance_call                                      as maintenance_call
    , a.mvl_cash_account_excluding_options                    as mvl_cash_account_excluding_options
    , a.net_market_value_positions_only                       as net_market_value_positions_only
    , a.net_market_value_positions_plus_cash_and_money_market as net_market_value_positions_plus_cash_and_money_market
    , a.cash_balance_settled_only                             as cash_balance_settled_only
    , a.cash_margin_balance_settled_only                      as cash_margin_balance_settled_only
    , a.version_marker_3                                      as version_marker_3
    , a.bank_sweep_interest_bearing_feature                   as bank_sweep_interest_bearing_feature
    , a.master_number                                         as master_number
    , a.is_deceased                                           as is_deceased
    , a.is_from_tda_migration                                 as is_from_tda_migration
    , a.effective_date                                        as effective_date
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                         as rn
    , row_number() over (
        partition by a.effective_date , a.account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                         as rn_firm_source
    , row_number() over (
        partition by a.effective_date , a.account_number
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                         as rn_global
    , current_timestamp()::timestamp_ntz                      as _created_at
    , a._source_loaded_at                                     as _source_loaded_at
    , a._source_file                                          as _source_file
from {{ source('schwab', 'rps_cash') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
    and a.effective_date
    between coalesce(cl.effective_start_date , a.effective_date) and coalesce(cl.effective_end_date , a.effective_date)
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
where 1 = 1
    and exists(select 1 from dates_to_refresh)
    and a.effective_date in (select distinct t.effective_date from dates_to_refresh as t)
