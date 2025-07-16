select
    'axys'::text(200)                                         as system_name
    , 'granite'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'                                                   as firm_source
    , effective_date::date                                    as effective_date
    , json:"account number"::text                             as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(json:"account number"::text) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                              as account_number
    , json:"report date"::text(200)                           as report_date
    , nullif(json:"market value"::text , '')::decimal(18 , 2) as market_value
    , json:"security type"::text(200)                         as security_type
    , json:"security"::text(200)                              as security
    , json:"security symbol"::text(200)                       as security_symbol
    , nullif(json:"total  cost"::text , '')::decimal(18 , 2)  as total_cost
    , json:"cusip"::text(200)                                 as cusip
    , nullif(json:"quantity"::text , '')::decimal(18 , 2)     as quantity
    , nullif(json:"price"::text , '')::decimal(18 , 2)        as price
    , json:"portfolio code"::text(200)                        as portfolio_code
    , {{ col_is_head(reference=source('axys_granite', 'accounts')) }}
    , _source_file::text(200)                                 as _source_file
    , _created_at::datetime                                   as _created_at
    , _id::int                                                as _id
from {{ source('axys_granite', 'holdings') }}
