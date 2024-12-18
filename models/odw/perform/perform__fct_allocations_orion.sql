with allocations_from_perform as (
    select
        trade_date                         as trade_date
        , custodian                        as custodian
        , order_id                         as order_id
        , broker_name                      as broker_name
        , cusip                            as cusip
        , account_number_formatted         as account_number_formatted
        , units                            as units
        , net                              as net
        , principal                        as principal
        , interest                         as interest
        , order_side                       as order_side
        , unit_price                       as unit_price

        , account_number_formatted || '_0' as line_item
        , trade_date                       as effective_date
    from {{ ref('perform__fct_allocations') }}
    where 1 = 1
)

, trades as (
    select
        to_char(trade_date , 'MM/DD/YYYY') as trans_date
        , custodian                        as custodian
        , order_id                         as orderid
        , broker_name                      as broker
        , cusip                            as cusip
        , account_number_formatted         as acct_code
        , units                            as units
        , net                              as amount
        , principal                        as principal
        , interest                         as interest
        , null::text                       as other

        , case
            when order_side ilike 'buy' then 10
            else 53
        end::int                           as trans_type
        , unit_price / 100                 as price

        , account_number_formatted || '_0' as line_item
        , trade_date                       as effective_date
    from allocations_from_perform
)

, cash_side as (
    select
        to_char(trade_date , 'MM/DD/YYYY') as trans_date
        , custodian                        as custodian
        , order_id                         as orderid
        , broker_name                      as broker
        , account_number_formatted         as acct_code
        , case
            when order_side ilike 'buy' then 53
            else 10
        end::int                           as trans_type
        , case
            when custodian ilike 'fidelity'
                then 'FID:CASH'
            when custodian ilike 'schwab'
                then 'SchwabCash'
            when custodian ilike 'stifel'
                then 'VESTMARKCASH'
            when custodian ilike 'pershing' then 'USD999997'
            when lower(custodian) in ('td' , 'td ameritrade' , 'tda')
                then '9ZZZFD989'
            else 'Cash:Sweep'
        end::text                          as cusip
        , 1.00::decimal(20 , 2)            as price
        , net                              as units
        , net                              as amount
        , null::decimal(20 , 2)            as principal
        , null::decimal(20 , 2)            as interest
        , null::text                       as other

        , account_number_formatted || '_1' as line_item
        , effective_date                   as effective_date
    from allocations_from_perform
)

, final as (
    select
        acct_code
        , cusip
        , trans_date
        , trans_type
        , amount
        , units
        , price
        , principal
        , interest
        , other
        , broker
        , orderid
        , line_item
        , effective_date
    from trades

    union all

    select
        acct_code
        , cusip
        , trans_date
        , trans_type
        , amount
        , units
        , price
        , principal
        , interest
        , other
        , broker
        , orderid
        , line_item
        , effective_date
    from cash_side
)

select
    acct_code
    , cusip
    , trans_date
    , trans_type
    , amount
    , units
    , price
    , principal
    , interest
    , other
    , broker
    , orderid
    , line_item
    , effective_date
from final
order by effective_date , line_item
