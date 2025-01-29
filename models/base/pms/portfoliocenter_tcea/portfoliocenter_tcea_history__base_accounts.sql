select
    'portfoliocenter'                              as system_name
    , 'tcea'                                       as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , hiddenportfolioid                            as hidden_portfolio_id
    , underlyinghiddenportfolioid                  as underlying_hidden_portfolio_id
    , as_of_date
    , price_date
    , closed_account
    , account_closed_date
    , account_number                               as account_number_formatted
    , regexp_replace(replace(
        ltrim(upper(account_number) , '0') , '-' , ''
    ) , '\\s{2,}' , ' ')                           as account_number
    , account_type
    , "ACCOUNT_CLASSIFICATION_-CF-"                as account_classification
    , advisor_description
    , advisor_name
    , billing_spec
    , custodian
    , description
    , discretionary_account
    , "ERISA_-CF-"                                 as erisa
    , first_name
    , last_name
    , "HOUSEHOLD_CODE_-CF-"                        as household_code
    , inception_date
    , market_value
    , objective
    , portfolio_type
    , "PROXY_VOTING_-CF-"                          as proxy_voting
    , total_value
    , {{ col_is_head(reference=source('portfoliocenter_tcea', 'fa_accounts_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('portfoliocenter_tcea', 'fa_accounts_history') }}
