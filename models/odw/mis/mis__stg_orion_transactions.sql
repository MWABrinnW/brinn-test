select
    a.content:account_number_formatted::text as account_number_formatted
    , a.content:account_number::text         as account_number
    , a.content:custodian::text              as custodian
    , a.content:account_id::int              as account_id
    , a.content:date::date                   as date
    , a.content:settlement_date::date        as settlement_date
    , a.content:created_date::date           as created_date
    , a.content:edited_date::date            as edited_date
    , a.content:symbol::text                 as symbol
    , a.content:cusip::text                  as cusip
    , a.content:ticker::text                 as ticker
    , a.content:is_ticker_cusip::int         as is_ticker_cusip
    , a.content:is_custodial_cash::int       as is_custodial_cash
    , a.content:product_name::text           as product_name
    , a.content:product_type::text           as product_type
    , a.content:product_category::text       as product_category
    , a.content:asset_class::text            as asset_class
    , a.content:product_id::int              as product_id
    , a.content:is_asset_managed::int        as is_asset_managed
    , a.content:is_product_managed::int      as is_product_managed
    , a.content:type_id::int                 as type_id
    , a.content:type_code::text              as type_code
    , a.content:type_name::text              as type_name
    , a.content:type_description::text       as type_description
    , a.content:quantity::decimal(20 , 5)    as quantity
    , a.content:price::decimal(20 , 5)       as price
    , a.content:amount::decimal(20 , 2)      as amount
    , a.content:sign_field::text             as sign_field
    , a.content:notes::text                  as notes
    , a.content:id::int                      as id
    , a.content:asset_id::int                as asset_id
    , a.content:type_cash_offset::text       as type_cash_offset
    , a.content:trade_status::text           as trade_status
    , a.content:trade_status_id::int         as trade_status_id
    , a.content:fkalclient::int              as fkalclient
    , a.content:_extracted_at::timestamp_tz  as _extracted_at
    , a.content:createddate::timestamp_ntz   as createddate
    , a._created_at                          as _created_at
    , row_number() over (
        partition by a.content:date::date , a.content:id::int
        order by a._created_at desc
    )                                        as rn
from {{ source('mis', 'orion_transactions') }} as a
