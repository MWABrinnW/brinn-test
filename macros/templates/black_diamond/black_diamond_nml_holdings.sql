{%- macro black_diamond_nml_holdings(instance) -%}

select
    --- [system] ---------------------------------------------------------------------
    effective_date::date                                     as effective_date
    , system_name::text(500)                                 as system_name
    , system_instance::text(500)                             as system_instance
    , system_key::text(500)                                  as system_key
    , firm_source::text(500)                                 as firm_source
    --- [account + holdings] -----------------------------------------------------------
    , account_id::text(500)                                  as account_id
    , account_number_formatted::text(500)                    as account_number_formatted
    , account_number::text(500)                              as account_number
    , null::text(500)                                        as client_id
    , null::text(500)                                        as client_name
    , custodian::text(500)                                   as custodian
    , cusip::text(500)                                       as cusip
    , ticker::text(500)                                      as ticker
    , null::int                                              as is_ticker_cusip
    , null::int                                              as is_custodial_cash
    , asset_id::text(500)                                    as security_id
    , asset_name::text(500)                                  as security_name
    , issue_type::text(500)                                  as security_type
    , null::text(500)                                        as security_subtype
    , class_name::text(500)                                  as asset_class
    , market_value::number(19, 9)                            as market_value
    , units::number(19, 9)                                   as quantity
    , price::number(19, 9)                                   as price
    , null::number(19 , 9)                                   as price_unfactored
    , null::number(19 , 9)                                   as factor
    , null::number(19 , 9)                                   as cost_basis
    , 0::int                                                 as is_legacy
    , 0::int                                                 as is_manual_holdings
    --- [meta] ---------------------------------------------------------------------
    , current_timestamp()::datetime                          as _created_at
    , _source_loaded_at::datetime                            as _source_loaded_at
    , null::text(500)                                        as _source_file
from {{ ref('black_diamond_' ~ instance ~ '__base_holdings') }}

{%- endmacro -%}
