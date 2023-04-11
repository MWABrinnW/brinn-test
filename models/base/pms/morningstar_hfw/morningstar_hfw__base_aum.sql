select
     effective_at::date                              as effective_date
    ,advisor_name                                   as advisor_name
    ,client_name                                    as client_name
    , account_name                                   as account_name
    ,account_number                                 as account_number
    ,current_custodian                              as custodian
    ,account_managed_by                             as account_managed_by
    ,investment_strategy                            as investment_strategy
    ,cash_amount::decimal(15,2)                     as cash_amount
    ,cash_percent::decimal(9,6) * .01               as cash_percent
    ,us_stock_amount::decimal(15,2)                 as us_stock_amount
    ,us_stock_percent::decimal(9,6) * .01           as us_stock_percent
    ,non_us_stock_amount::decimal(15,2)             as non_us_stock_amount
    ,non_us_stock_percent::decimal(9,6) * .01       as non_us_stock_percent
    ,bond_amount::decimal(15,2)                     as bond_amount
    ,bond_percent::decimal(9,6) * .01               as bond_percent
    ,other_amount::decimal(15,2)                    as other_amount
    ,other_percent::decimal(9,6) * .01              as other_percent
    ,not_classified_amount::decimal(15,2)           as not_classified_amount
    ,not_classified_percent::decimal(9,6)           as not_classified_percent
    ,total_account::decimal(15,2)                   as total_account_amount
    ,{{ col_is_head(reference=source('morningstar_hfw', 'aum'), reference_date_col='effective_at', source_date_col='effective_at') }}
    ,{{ col_is_current(date_col='effective_at') }}
    ,effective_at
    ,_created_at
    ,_source_file
from {{ source('morningstar_hfw', 'aum') }}
