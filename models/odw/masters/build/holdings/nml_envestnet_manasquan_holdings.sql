select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                  as effective_date
    , system_name::text(200)              as system_name
    , system_instance::text(200)          as system_instance
    , system_key::text(200)               as system_key
    , firm_source::text(200)              as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , account_id::text(200)               as account_id
    , account_number_formatted::text(200) as account_number_formatted
    , account_number::text(200)           as account_number
    , null::text(200)                     as client_id
    , null::text(200)                     as client_name
    , null::text(200)                     as custodian
    , cusip::text(200)                    as cusip
    , ticker::text(200)                   as ticker
    , null::int                           as is_ticker_cusip
    , null::int                           as is_custodial_cash
    , security_id::text(200)              as security_id
    , description::text(200)              as security_name
    , security_type::text(200)            as security_type
    , null::text(200)                     as security_subtype
    , null::text(200)                     as asset_class
    , market_value::number(19 , 9)        as market_value
    , quantity::number(19 , 9)            as quantity
    , market_price::number(19 , 9)        as price
    , null::number(19 , 9)                as price_unfactored
    , null::number(19 , 9)                as factor
    , total_cost::number(19 , 9)          as cost_basis
    --- [meta] ----------------------------------------------------------------------
    , is_head::int                        as is_head
    , is_current::int                     as is_current
    , _created_at::datetime               as _source_loaded_at
    , null::text(200)                     as _source_file
from {{ ref('envestnet_manasquan__stg_positions') }}
