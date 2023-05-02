select
    'portfoliocenter' as pms
    , 'roseland' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , hiddenportfolioid
    , underlyinghiddenportfolioi
    , portfolio_type
    , account_number
    , account_type
    , advisor_description
    , discretionary_account
    , objective
    , advisor_name
    , custodian
    , custodian_name_cf
    , billing_spec
    , description
    , first_name
    , last_name
    , market_value
    , total_value
    , as_of_date
    , price_date
    , account_closed_date
    , inception_date
    , {{ col_is_head(reference=source('portfoliocenter_roseland', 'financial_accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('portfoliocenter_roseland', 'financial_accounts') }}