select
    effective_date::date                       as effective_date
    , json:system_name::varchar(200)           as system_name
    , json:system_instance::text(200)          as system_instance
    , json:system_key::text(200)               as system_key
    , json:firm_source::text(200)              as firm_source
    , json:account_id::text(200)               as account_id
    , json:account_number_formatted::text(200) as account_number_formatted
    , json:account_number::text(200)           as account_number
    , json:client_id::number(38 , 5)           as client_id
    , json:client_name::varchar(400)           as client_name
    , json:custodian::text(200)                as custodian
    , json:cusip::text(200)                    as cusip
    , json:ticker::text(200)                   as ticker
    , json:is_ticker_cusip::int                as is_ticker_cusip
    , json:is_custodial_cash::int              as is_custodial_cash
    , json:security_id::number(38 , 5)         as security_id
    , json:security_name::text(200)            as security_name
    , json:security_type::text(200)            as security_type
    , json:security_subtype::text(200)         as security_subtype
    , json:asset_class::text(200)              as asset_class
    , json:market_value::float                 as market_value
    , json:quantity::float                     as quantity
    , json:price::float                        as price
    , json:price_unfactored::number(19 , 9)    as price_unfactored
    , json:factor::number(19 , 9)              as factor
    , json:cost_basis::float                   as cost_basis
    , 1::int                                   as is_manual_holdings
    , _created_at::datetime                    as _created_at
from {{ source('manual', 'holdings_manual') }}
