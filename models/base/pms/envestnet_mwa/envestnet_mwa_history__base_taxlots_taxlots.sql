select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , effective_date
    , account_id
    , account_number
    , as_of_date
    , security_id
    , cusip
    , ticker
    , quantity
    , market_value
    , total_cost
    , market_price
    , purchase_date
    , accrued_income
    , accrued_interest
    , unsupervised_indicator
    , short_position_indicator
    , itd_performance
    , inception_date
    , security_type
    , security_style
    , currency
    , tax_currency
    , {{ col_is_head(reference=source('envestnet_mwa', 'taxlots_taxlots')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('envestnet_mwa', 'taxlots_taxlots') }}


