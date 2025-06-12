select
    effective_date::date                    as effective_date
    , json:system_name::text                as system_name
    , json:system_instance::text            as system_instance
    , json:system_key::text                 as system_key
    , json:firm_source::text                as firm_source
    , json:account_id::text                 as account_id
    , json:account_number_formatted::text   as account_number_formatted
    , json:account_number::text             as account_number
    , json:client_id::text                  as client_id
    , json:client_name::text                as client_name
    , json:custodian::text                  as custodian
    , json:cusip::text                      as cusip
    , json:ticker::text                     as ticker
    , json:is_ticker_cusip::int             as is_ticker_cusip
    , json:is_custodial_cash::int           as is_custodial_cash
    , json:security_id::text                as security_id
    , json:security_name::text              as security_name
    , json:security_type::text              as security_type
    , json:security_subtype::text           as security_subtype
    , json:asset_class::text                as asset_class
    , json:market_value::number(19 , 9)     as market_value
    , json:quantity::number(19 , 9)         as quantity
    , json:price::number(19 , 9)            as price
    , json:price_unfactored::number(19 , 9) as price_unfactored
    , json:factor::number(19 , 9)           as factor
    , 0::int                                as is_legacy
    , 1::int                                as is_manual_holdings
    , json:cost_basis::number(19 , 9)       as cost_basis
    , _created_at::timestamp_ntz            as _created_at
    , _created_at::timestamp_ntz            as _source_loaded_at
    , null::text                            as _source_file
from {{ source('raw_pms', 'holdings_manual') }}
where 1 = 1
order by effective_date , system_key , account_number
