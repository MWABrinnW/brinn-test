select
    'envestnet'                                    as system_name
    , 'manasquan'                                  as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , account_id::varchar(200)                     as account_id
    , upper(account_number)                        as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(account_number) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                   as account_number
    , as_of_date
    , security_id
    , cusip
    , ticker
    , description
    , security_type
    , security_style
    , quantity
    , market_value
    , total_cost
    , market_price
    , accrued_income
    , accrued_interest
    , unsupervised_indicator
    , short_position_indicator
    , unsupervised_start_date
    , currency
    , tax_currency
    , {{ col_is_head(reference=source('envestnet_mwa', 'positions_positions')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mwa', 'positions_positions') }}
