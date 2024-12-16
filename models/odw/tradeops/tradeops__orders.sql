select
    a.system_key                                                  as system_key
    , a.order_trade_date                                          as trade_date
    , a.transaction_time                                          as trade_executed_at
    , case a.order_current_order_status
        when '0' then 'New'
        when '1' then 'Partially filled'
        when '2' then 'Filled'
        when '3' then 'Done for day'
        when '4' then 'Canceled'
        when '5' then 'Replaced'
        when '6' then 'Pending Cancel'
        when '7' then 'Stopped'
        when '8' then 'Rejected'
        when '9' then 'Suspended'
        when 'A' then 'Pending New'
        when 'B' then 'Calculated'
        when 'C' then 'Expired'
        when 'D' then 'Accepted for Bidding'
        when 'E' then 'Pending Replace'
        when null then 'Cancelled'
        else a.order_current_order_status
    end::text(200)                                                as status

    , a.order_client_order_id                                     as order_id
    , a.order_block_id                                            as block_id
    , a.target_comp_id                                            as broker_name

    , case
        when a.order_side = 1
            then 'BUY'
        when a.order_side = 2
            then 'SELL'
    end::text(200)                                                as order_side
    -- Is this the id for order effect?
    , a.order_type                                                as order_effect

    , a.order_asset_class                                         as asset_class
    , a.symbol                                                    as ticker
    , a.underlying_symbol                                         as underlying_ticker
    , sum(a.member_original_order_qty)::decimal(18 , 3)           as order_quantity
    , sum(a.member_quantity)                                      as filled_quantity
    , avg(a.order_price)                                          as avg_price
    , min(a.order_price)                                          as min_price
    , max(a.order_price)                                          as max_price

    , sum(a.net_money)::decimal(18 , 2)                           as net_amount
    -- Take these from member?
    , sum(a.order_commission)::decimal(18 , 2)                    as commission
    , sum(a.member_principal)::decimal(18 , 2)                    as principal
    , sum(a.member_accrued_interest_amount)::decimal(18 , 2)      as interest
    , sum(a.member_sec_fee + a.member_other_fee)::decimal(18 , 2) as fees

    , a.order_trader_name                                         as created_by

    , count(distinct a.member_indiv_alloc_id)                     as allocations

    , a.order_option_maturity_date                                as option_expiration_date
    , a.order_option_strike_price                                 as option_strike_price
    , a.order_option_put_or_call                                  as option_type

    , max(a._created_at)                                          as last_collected_at
from {{ ref('flyer__stg_orders_allocations') }} as a
where 1 = 1
    and a.is_head = 1
group by all
order by a.order_trade_date desc , a.transaction_time asc
