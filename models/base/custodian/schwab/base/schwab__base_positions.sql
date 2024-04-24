-- depends_on: {{ ref('schwab__stg_positions') }}

select
    a.custodian
    , cl.firm_source
    , cf.firm
    , a.record_type
    , a.custodian_id
    , a.master_account_number
    , a.master_account_name
    , a.business_date
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
    , a.dividend_reinvest
    , a.capital_gains_reinvest
    , a.closing_price
    , a.security_price_update_date
    , a.quantity_settled_and_unsettled
    , a.long_short_indicator
    , a.market_value_settled_and_unsettled
    , a.accounting_rule_code
    , a.quantity_settled
    , a.quantity_unsettled_long
    , a.quantity_unsettled_short
    , a.version_marker_1
    , a.tips_factor
    , a.asset_backed_factor
    , a.version_marker_2
    , a.closing_price_unfactored
    , a.factor
    , a.factor_date
    , a.master_number
    , a.is_deceased
    , a.is_from_tda_migration
    , a.effective_date
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
    , {{ col_is_head(reference=source('schwab', 'rps_positions')) }}
    , {{ col_is_current(date_col='a.effective_date') }}
    , a._source_loaded_at
    , a._source_file
from {{ source('schwab', 'rps_positions') }} as a
left join {{ ref('aux__stg_custodian_links') }} as cl
    on a.master_number = cl.link
    and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }} as cf
    on cl.firm_source = cf.firm_source
