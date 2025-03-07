select
    --- [system] ---------------------------------------------------------------------
    effective_date                        as effective_date
    , system_name                         as system_name
    , system_instance                     as system_instance
    , system_key                          as system_key
    , firm_source                         as firm_source
    --- [account + holdings] ----------------------------------------------------------
    , portfolio_code::text(200)           as account_id
    , account_number_formatted::text(200) as account_number_formatted
    , account_number::text(200)           as account_number
    , null::text(200)                     as client_id
    , null::text(200)                     as client_name
    , null::text(200)                     as custodian
    , cusip::text(200)                    as cusip
    , security_symbol::text(200)          as ticker
    , null::int                           as is_ticker_cusip
    , null::int                           as is_custodial_cash
    , null::text(200)                     as security_id
    , security::text(200)                 as security_name
    , security_type::text(200)            as security_type
    , null::text(200)                     as security_subtype
    , null::text(200)                     as asset_class
    , market_value::number(19 , 9)        as market_value
    , quantity::number(19 , 9)            as quantity
    , price::number(19 , 9)               as price
    , null::number(19 , 9)                as price_unfactored
    , null::number(19 , 9)                as factor
    , total_cost::number(19 , 9)          as cost_basis
    --- [meta] ---------------------------------------------------------------------
    , is_head::int                        as is_head
    , null::int                           as is_current
    , _created_at::datetime               as _source_loaded_at
    , null::text(200)                     as _source_file
from {{ ref('axys_granite__stg_holdings') }}
