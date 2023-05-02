select
    'portfoliocenter' as pms
    , 'tcea' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , hiddenportfolioid
    , underlyinghiddenportfolioid
    , as_of_date
    , price_date
    , closed_account
    , account_closed_date
    , account_number
    , account_type
    , 'account_classification_-cf-'
    , advisor_description
    , advisor_name
    , billing_spec
    , custodian
    , description
    , discretionary_account
    , 'erisa_-cf-'
    , first_name
    , last_name
    , 'household_code_-cf-'
    , inception_date
    , market_value
    , objective
    , portfolio_type
    , 'proxy_voting_-cf-'
    , total_value
    , {{ col_is_head(reference=source('portfoliocenter_tcea', 'fa_accounts_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('portfoliocenter_tcea', 'fa_accounts_history') }}