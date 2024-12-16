select
    t.system_key          as system_key
    , t.account_number    as account_number
    , t.custodian         as custodian
    , t.account_id        as account_id
    , t.date              as date
    , t.settlement_date   as settlement_date
    , t.trade_status      as trade_status
    , t.symbol            as symbol
    , t.ticker            as ticker
    , t.cusip             as cusip
    , t.is_ticker_cusip   as is_ticker_cusip
    , t.is_trade          as is_trade
    , t.buy_sell          as buy_sell
    , t.type_name         as transaction_type
    , t.type_description  as transaction_type_detail
    , t.quantity          as quantity
    , t.price             as price
    , t.amount            as amount
    , t.sign_field        as sign_field
    , t.id                as id
    , t.product_name      as product_name
    , t.asset_class       as asset_class
    , t.asset_id          as asset_id
    , t.product_type      as product_type
    , t.product_category  as product_category
    , t.product_id        as product_id
    , t.is_custodial_cash as is_custodial_cash
    , a.trading_systems   as trading_systems
    , a.is_included       as is_included
    , t.notes             as notes

    , t.is_head           as is_head
    , t._created_at       as _created_at
    , t._source_loaded_at as _source_loaded_at
from {{ ref('orion__transactions') }} as t
left join {{ ref('mis__bld_accounts') }} as a
    on t.account_number = a.account_number
    and a.is_included = 1
