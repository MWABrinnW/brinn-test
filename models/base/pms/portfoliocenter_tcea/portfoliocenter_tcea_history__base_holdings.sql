select
    'portfoliocenter' as pms
    , 'tcea' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , hiddenportfolioid
    , underlyinghiddenportfolioid
    , as_of_date
    , price_date
    , portfolio_account_number
    , portfolio_description
    , 'household_code_-cf-'
    , portfolio_type
    , asset_class_description
    , current_price
    , cusip
    , sector_description
    , security_comment
    , security_description
    , security_type
    , subsector_description
    , symbol
    , cost_basis
    , market_value
    , original_trade_date
    , quantity
    , total_value
    , {{ col_is_head(reference=source('portfoliocenter_tcea', 'fa_holdings_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('portfoliocenter_tcea', 'fa_holdings_history') }}