-- depends_on: {{ ref('schwab__stg_open_lots_nontaxable') }}

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
  , a.symbol_ticker
  , a.cusip
  , a.schwab_internal_id
  , a.item_issue_id
  , a.isin
  , a.sedol
  , a.options_display_symbol
  , a.underlying_ticker_symbol
  , a.underlying_cusip
  , a.underlying_schwab_internal_id
  , a.underlying_item_issue_id
  , a.underlying_isin
  , a.underlying_sedol
  , a.current_quantity
  , a.long_short_indicator
  , a.transaction_code
  , a.current_market_value
  , a.accrued_interest_fixed_income
  , a.acquired_date
  , a.original_purchase_date
  , a.original_purchase_price
  , a.yield_to_maturity_fixed_income
  , a.cost_basis_unamortized_cost_basis_amount
  , a.cost_per_share_share_cost_amount
  , a.adjusted_cost_basis_amortized_cost_basis_amount
  , a.adjusted_cost_per_share
  , a.unrealized_gain_loss_ugl
  , a.number_of_days_held
  , a.holding_period_term
  , a.cost_basis_fully_known
  , a.cost_basis_type
  , a.account_taxable_indicator
  , a.certified_indicator
  , a.original_face
  , a.account_lot_selection_method_default
  , a.wash_sale_impacted
  , a.version_marker_1
  , a.disallowed_loss
  , a.transaction_cost
  , a.transaction_cost_per_share
  , a.version_marker_2
  , a.acquisition_type_gift_or_inherited
  , a.original_cost_basis
  , a.version_marker_3
  , a.adjusted_cost_including_unpaid_amortization
  , a.master_number
  , a.is_deceased
  , a.is_from_tda_migration
  , a.effective_date
  , a.rn
  , {{ col_is_head(reference=source('schwab', 'uln_open_lots_nontaxable')) }}
  , {{ col_is_current(date_col='a.effective_date') }}
  , a._source_loaded_at
  , a._source_file
from {{ source('schwab', 'uln_open_lots_nontaxable') }} a
left join {{ ref('aux__stg_custodian_links') }}         cl
          on a.master_number = cl.link
              and cl.custodian = 'schwab'
left join {{ ref('custodian_firms') }}                  cf
          on cl.firm_source = cf.firm_source
