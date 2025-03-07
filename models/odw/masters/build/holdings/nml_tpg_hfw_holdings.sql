select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                  as effective_date
    , system_name::text(200)              as system_name
    , system_instance::text(200)          as system_instance
    , system_key::text(200)               as system_key
    , firm_source::text(200)              as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , null::text(200)                     as account_id
    , account_number_formatted::text(200) as account_number_formatted
    , account_number::text(200)           as account_number
    , null::text(200)                     as client_id
    , client_name::text(200)              as client_name
    , null::text(200)                     as custodian
    , cusip::text(200)                    as cusip
    , null::text(200)                     as ticker
    , null::int                           as is_ticker_cusip
    , null::int                           as is_custodial_cash
    , null::text(200)                     as security_id
    , cusip_type_desc::text(200)          as security_name
    , security_type::text(200)            as security_type
    , null::text(200)                     as security_subtype
    , null::text(200)                     as asset_class
    , market_value::number(19 , 9)        as market_value
    , null::number(19 , 9)                as quantity
    , price::number(19 , 9)               as price
    , null::number(19 , 9)                as price_unfactored
    , null::number(19 , 9)                as factor
    , cost_basis::number(19 , 9)          as cost_basis
    --- [meta] ----------------------------------------------------------------------
    , is_head::int                        as is_head
    , is_current::int                     as is_current
    , _created_at::datetime               as _source_loaded_at
    , _source_file::text(200)             as _source_file
from {{ ref('tpg_hfw__stg_holdings') }}
-- dedupes holdings records found in multiple files for the same effective date 
where rn = 1
