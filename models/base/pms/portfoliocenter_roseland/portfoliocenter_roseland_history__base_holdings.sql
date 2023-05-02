select
    'portfoliocenter' as pms
    , 'roseland' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , hiddenportfolioid
    , underlyinghiddenportfolioid
    , portfolio_account_number
    , portfolio_type
    , portfolio_description
    , as_of_date
    , pricedate
    , original_trade_date
    , cusip
    , symbol
    , subsector_description
    , asset_class_description
    , sector_description
    , security_type
    , security_description
    , security_comment
    , current_price
    , cost_basis
    , quantity
    , total_value
    , market_value
    , {{ col_is_head(reference=source('portfoliocenter_roseland', 'holdings_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('portfoliocenter_roseland', 'holdings_monthly') }}