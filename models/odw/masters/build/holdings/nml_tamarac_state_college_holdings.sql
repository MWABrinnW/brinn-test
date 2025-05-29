select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                     as effective_date
    , system_name::text(200)                 as system_name
    , system_instance::text(200)             as system_instance
    , system_key::text(200)                  as system_key
    , firm_source::text(200)                 as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , upload_account_id::text(200)           as account_id
    , account_number_formatted::text(200)    as account_number_formatted
    , account_number::text(200)              as account_number
    , null::text(200)                        as client_id
    , null::text(200)                        as client_name
    , null::text(200)                        as custodian
    , cusip::text(200)                       as cusip
    , symbol::text(200)                      as ticker
    , null::int                              as is_ticker_cusip
    , null::int                              as is_custodial_cash
    , upload_security_id::text(200)          as security_id
    , security_description::text(200)        as security_name
    , security_type::text(200)               as security_type
    , null::text(200)                        as security_subtype
    , asset_class::text(200)                 as asset_class
    , holdings_current_value::number(19 , 9) as market_value
    , quantity::number(19 , 9)               as quantity
    , price::number(19 , 9)                  as price
    , null::number(19 , 9)                   as price_unfactored
    , null::number(19 , 9)                   as factor
    , cost_basis::number(19 , 9)             as cost_basis
    --- [meta] ----------------------------------------------------------------------
    , is_head::int                           as is_head
    , is_current::int                        as is_current
    , _created_at::datetime                  as _created_at
    , _created_at::datetime                  as _source_loaded_at
    , null::text(200)                        as _source_file
from {{ ref('tamarac_state_college_history__base_holdings') }}
