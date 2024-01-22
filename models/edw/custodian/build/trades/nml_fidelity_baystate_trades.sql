select
    t.effective_date
  , t.custodian
  , t.firm
  , t.firm_source
  , t.account_number
  , t.account_number_formatted
  , t.custodian_link
  , t.custodian_link_detail
  , t.rep_link
  , t.rep_link_detail
  , t.account_type
  , t.account_type_source_definition
  , t.account_type_source_code
  , t.symbol
  , t.ticker
  , t.cusip
  , t.transaction_date
  , t.settlement_date
  , t.entry_date
  , t.buy_sell
  , t.units_shares
  , t.price
  , t.gross_amount
  , t.net_amount
  , t.commission
  , t.closing_price
  , t.closing_price_unfactored
  , t.factor
  , t.factor_date
  , t.debit_credit_indicator
  , t.trade_executed_at
  , t.is_canceled
  , t.isin
  , t.sedol
  , t.transaction_id_source
  , t.transaction_id
  , t.product_type
  , t.product_type_source_definition
  , t.product_type_source_code
  , t.is_head
  , t.is_current
  , t._source_loaded_at
  , t._source_file
from {{ ref('nml_fidelity_baystate_transactions') }} t
where 1=1
    and t.is_trade = 1
