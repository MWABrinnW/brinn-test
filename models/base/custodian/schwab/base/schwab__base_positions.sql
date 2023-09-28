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
  , a.account_number
  , a.product_code
  , a.product_category_code
  , a.tax_code
  , a.legacy_security_type
  , a.ticker_symbol
  , a.industry_ticker_symbol
  , a.cusip
  , a.schwab_security_number
  , a.item_issue_id
  , a.rule_set_suffix_id
  , a.isin
  , a.sedol
  , a.options_display_symbol
  , a.security_description_line_1
  , a.security_description_line_2
  , a.security_description_line_3
  , a.security_description_line_4
  , a.underlying_ticker_symbol
  , a.underlying_industry_ticker_symbol
  , a.underlying_cusip
  , a.underlying_schwab_security_number
  , a.underlying_item_issue_id
  , a.underlying_rule_set_suffix_id
  , a.underlying_isin
  , a.underlying_sedol
  , a.money_market_code
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
  , a.rn
  , {{ col_is_head(reference=source('schwab', 'rps_positions')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at
  , a._source_file
from {{ source('schwab', 'rps_positions') }}    a
left join {{ ref('aux__stg_custodian_links') }} cl
          on a.master_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}          cf
          on cl.firm_source = cf.firm_source
