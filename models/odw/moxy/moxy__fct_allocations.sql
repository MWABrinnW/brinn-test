with cte_dates as (
    select
        traded_at::date    as trade_date
        , max(_created_at) as max_created_at
    from {{ ref('moxy__stg_allocations') }}
    group by all
    order by 1
)

select
    a.system_key                                 as system_key
    , a.order_id                                 as order_id
    , a.allocation_id                            as allocation_id
    , a.traded_at::date                          as trade_date
    , a.settle_date                              as settle_date
    , lower(a.custodian_symbol)                  as custodian
    , a.account_number                           as account_number_source
    , acc.account_number                         as account_number

    , a.symbol                                   as symbol
    , a.cusip                                    as cusip
    , case
        when lower(a.transaction_type) in ('buy' , 'cover')
            then 'buy'
        when lower(a.transaction_type) = 'sell'
            then 'sell'
    end::text                                    as order_side
    , 'long'::text(500)                          as order_effect

    , a.security_type_code                       as source_security_type
    , a.full_name                                as source_security_description
    , a.alloc_qty                                as quantity
    , a.alloc_price                              as price
    , a.principal_amt                            as principal
    , null::decimal(18 , 2)                      as interest
    , a.net_amt                                  as net
    , a.portfolio_code                           as portfolio_id
    , a.portfolio_id                             as account_id
    , lower(a.executing_broker_firm_symbol)      as broker_name
    , null::text                                 as broker_id
    , null::text                                 as owner
    , coalesce(broker_name != custodian , false) as trade_away

    , 'mwa'::text                                as firm
    , 'cincinnati'::text                         as venue
    , 'moxy'::text                               as platform

    , a.created_by                               as trader
    , convert_timezone('UTC' , a.traded_at)      as traded_at
    , a.system_name                              as system_name
    , a.system_instance                          as system_instance

    , a._created_at                              as _created_at
    , a._source_file                             as _source_file
from {{ ref('moxy__stg_allocations') }} as a
left join cte_dates as b
    on a.traded_at::date = b.trade_date
left join {{ ref('mis__accounts') }} as acc
    on lower(a.portfolio_code) = lower(acc.trading_id)
where 1 = 1
    and a._created_at = b.max_created_at
