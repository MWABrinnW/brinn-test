select
    'axys'                                         as system_name
    , 'cincinnati'                                 as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , as_of_date                                   as effective_date
    , portfolio_code
    , portfolio_name
    , customer_account_number
    , custodian
    , cash_and_equivalents
    , fixed_income
    , equities
    , other
    , total
    , portfolio_status
    , account_source
    , start_date
    , company_name
    , goal
    , type
    , {{ col_is_head(reference=source('axys_cincinnati', 'financial_account'), reference_date_col='as_of_date') }}
    , {{ col_is_current(date_col='as_of_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('axys_cincinnati', 'financial_account') }}
