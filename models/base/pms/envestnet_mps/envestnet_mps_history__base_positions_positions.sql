select
    'envestnet'                                    as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , account_id
    , account_number
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
    , itd_performance
    , inception_date
    , unsupervised_start_date
    , {{ col_is_head(reference=source('envestnet_mps', 'positions_positions')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('envestnet_mps', 'positions_positions') }}
