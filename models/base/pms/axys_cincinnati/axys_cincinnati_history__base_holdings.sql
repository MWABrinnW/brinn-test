select
    'axys'                                         as system_name
    , 'cincinnati'                                 as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , portfolio_code
    , portfolio_name
    , market_value
    , start_date
    , asset_class
    , industry_name
    , cusip
    , security_name
    , security_symbol
    , sector
    , security_type
    , quantity
    , price
    , cost
    , adj_cost
    , {{ col_is_head(reference=source('axys_cincinnati', 'holdings_monthly')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('axys_cincinnati', 'holdings_monthly') }}
