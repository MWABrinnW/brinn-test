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
    from {{ source('schwab', 'rps_positions') }}
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
    a.custodian                                        as custodian
    , cl.firm_source                                   as firm_source
    , cf.firm                                          as firm
    , a.record_type                                    as record_type
    , a.custodian_id                                   as custodian_id
    , a.master_account_number                          as master_account_number
    , a.master_account_name                            as master_account_name
    , a.business_date                                  as business_date
    , nullif(a.account_number , '')                    as account_number
    , nullif(a.product_code , '')                      as product_code
    , nullif(a.product_category_code , '')             as product_category_code
    , nullif(a.tax_code , '')                          as tax_code
    , nullif(a.legacy_security_type , '')              as legacy_security_type
    , nullif(a.ticker_symbol , '')                     as ticker_symbol
    , nullif(a.industry_ticker_symbol , '')            as industry_ticker_symbol
    , nullif(a.cusip , '')                             as cusip
    , nullif(a.schwab_security_number , '')            as schwab_security_number
    , nullif(a.item_issue_id , '')                     as item_issue_id
    , nullif(a.rule_set_suffix_id , '')                as rule_set_suffix_id
    , nullif(a.isin , '')                              as isin
    , nullif(a.sedol , '')                             as sedol
    , nullif(a.options_display_symbol , '')            as options_display_symbol
    , nullif(a.security_description_line_1 , '')       as security_description_line_1
    , nullif(a.security_description_line_2 , '')       as security_description_line_2
    , nullif(a.security_description_line_3 , '')       as security_description_line_3
    , nullif(a.security_description_line_4 , '')       as security_description_line_4
    , nullif(a.underlying_ticker_symbol , '')          as underlying_ticker_symbol
    , nullif(a.underlying_industry_ticker_symbol , '') as underlying_industry_ticker_symbol
    , nullif(a.underlying_cusip , '')                  as underlying_cusip
    , nullif(a.underlying_schwab_security_number , '') as underlying_schwab_security_number
    , nullif(a.underlying_item_issue_id , '')          as underlying_item_issue_id
    , nullif(a.underlying_rule_set_suffix_id , '')     as underlying_rule_set_suffix_id
    , nullif(a.underlying_isin , '')                   as underlying_isin
    , nullif(a.underlying_sedol , '')                  as underlying_sedol
    , nullif(a.money_market_code , '')                 as money_market_code
    , a.dividend_reinvest                              as dividend_reinvest
    , a.capital_gains_reinvest                         as capital_gains_reinvest
    , a.closing_price                                  as closing_price
    , a.security_price_update_date                     as security_price_update_date
    , a.quantity_settled_and_unsettled                 as quantity_settled_and_unsettled
    , a.long_short_indicator                           as long_short_indicator
    , a.market_value_settled_and_unsettled             as market_value_settled_and_unsettled
    , a.accounting_rule_code                           as accounting_rule_code
    , a.quantity_settled                               as quantity_settled
    , a.quantity_unsettled_long                        as quantity_unsettled_long
    , a.quantity_unsettled_short                       as quantity_unsettled_short
    , a.version_marker_1                               as version_marker_1
    , a.tips_factor                                    as tips_factor
    , a.asset_backed_factor                            as asset_backed_factor
    , a.version_marker_2                               as version_marker_2
    , a.closing_price_unfactored                       as closing_price_unfactored
    , a.factor                                         as factor
    , a.factor_date                                    as factor_date
    , a.master_number                                  as master_number
    , a.is_deceased                                    as is_deceased
    , a.is_from_tda_migration                          as is_from_tda_migration
    , a.effective_date                                 as effective_date
    , dense_rank() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                  as rn
    , dense_rank() over (
        partition by a.effective_date , account_number , cl.firm_source
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                  as rn_firm_source
    , dense_rank() over (
        partition by a.effective_date , account_number
        order by {{ schwab_master_rank(col='a.master_number') }} asc , a.master_number
    )                                                  as rn_global
    , current_timestamp()::timestamp_ntz               as _created_at
    , a._source_loaded_at                              as _source_loaded_at
    , a._source_file                                   as _source_file
from {{ source('schwab', 'rps_positions') }} as a
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
order by a.effective_date
