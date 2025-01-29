select
    'portfoliocenter'                              as system_name
    , 'tcea'                                       as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , upper(portfolio_account_number)              as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(portfolio_account_number) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                   as account_number
    , effective_date
    , hiddenportfolioid
    , underlyinghiddenportfolioid
    , as_of_date
    , price_date
    , portfolio_description
    , "HOUSEHOLD_CODE_-CF-"                        as household_code
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
    , record_datetime                              as _source_loaded_at
from {{ source('portfoliocenter_tcea', 'fa_holdings_history') }}
