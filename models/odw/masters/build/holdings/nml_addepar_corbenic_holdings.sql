select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                             as effective_date
    , system_name::text(200)                         as system_name
    , system_instance::text(200)                     as system_instance
    , system_key::text(200)                          as system_key
    , firm_source::text(200)                         as firm_source
    --- [account + holdings] ---------------------------------------------------------
    , top_level_holding_account_entity_id::text(200) as account_id
    , account_number_formatted::text(200)            as account_number_formatted
    , account_number::text(200)                      as account_number
    , null::text(200)                                as client_id
    , null::text(200)                                as client_name
    , cwm_custodian::text(200)                       as custodian
    , cusip::text(200)                               as cusip
    , ticker_symbol::text(200)                       as ticker
    , null::int                                      as is_ticker_cusip
    , null::int                                      as is_custodial_cash
    , security_entity_id::text(200)                  as security_id
    , security::text(200)                            as security_name
    , actual_security_type::text(200)                as security_type
    , null::text(200)                                as security_subtype
    , cwm_asset_class::text(200)                     as asset_class
    , value::number(19 , 9)                          as market_value
    , quantity::number(19 , 9)                       as quantity
    , price_usd::number(19 , 9)                      as price
    , null::number(19 , 9)                           as price_unfactored
    , null::number(19 , 9)                           as factor
    , original_cost_basis_usd::number(19 , 9)        as cost_basis
    --- [meta] ---------------------------------------------------------------------
    , is_head::int                                   as is_head
    , is_current::int                                as is_current
    , _created_at::datetime                          as _source_loaded_at
    , null::text(200)                                as _source_file
from {{ ref('addepar_corbenic_history__base_holdings') }}
