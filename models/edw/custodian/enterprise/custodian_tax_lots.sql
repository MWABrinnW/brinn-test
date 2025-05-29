select
    bctl.effective_date
    , bctl.custodian
    , bctl.firm
    , bctl.firm_source
    , bctl.account_number
    , bctl.account_number_formatted
    , bctl.symbol
    , bctl.ticker
    , bctl.cusip
    , bctl.quantity
    , bctl.cost_per_share
    , bctl.cost_basis
    , bctl.current_price
    , bctl.current_value
    , bctl.trade_date
    , bctl.settlement_date
    , bctl.entry_date_source
    , bctl.is_cash
    , bctl.is_sweep
    , bctl.is_short
    , bctl.is_wash_sale
    , bctl.lot_id_source
    , bctl.security_id_source
    , bctl.option_ticker
    , bctl.option_indicator
    , bctl.option_expiration_date
    , bctl.option_strike_price
    , bctl.isin
    , bctl.sedol
    , bctl.product_type
    , bctl.product_type_source_definition
    , bctl.product_type_source_code
    , bctl.legacy_product_type
    , bctl.legacy_product_type_source_definition
    , bctl.legacy_product_type_source_code
    , {{ col_is_head(reference=ref('bld_custodian_tax_lots'), source_date_col='bctl.effective_date') }}
    , {{ col_is_current(date_col='bctl.effective_date') }}
    , bctl.rn_global
    , bctl._extra_fields
    , bctl._source_loaded_at
    , bctl._source_file
    , bctl._created_at
from {{ ref('bld_custodian_tax_lots') }} as bctl
