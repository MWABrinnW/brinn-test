{% set src = source('emoney_mwa', 'holdings') %}
select
    try_to_number(_data:"value"::text , 28 , 10)::int   as value
    , _data:"description"::text(200)                    as description
    , _data:"clientid"::text(200)                       as client_id
    , _data:"costbasis"::text(200)                      as cost_basis
    , _data:"asof"::text(200)                           as as_of
    , _data:"assetclass"::text(200)                     as asset_class
    , _data:"holdingtype"::text(200)                    as holding_type
    , _data:"securitytype"::text(200)                   as security_type
    , _data:"accountid"::text(200)                      as account_id
    , _data:"investmentstyle"::text(200)                as investment_style
    , _data:"holdingid"::text(200)                      as holding_id
    , _data:"acquiredate"::text(200)                    as acquire_date
    , _data:"industrysector"::text(200)                 as industry_sector
    , _data:"marketprice"::text(200)                    as market_price
    , _data:"cusip"::text(200)                          as cusip
    , _data:"ticker"::text(200)                         as ticker
    , try_to_number(_data:"units"::text , 28 , 10)::int as units

    , effective_date::date                              as effective_date
    , _created_at::timestamp                            as _created_at
    , _source_file::text(200)                           as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
