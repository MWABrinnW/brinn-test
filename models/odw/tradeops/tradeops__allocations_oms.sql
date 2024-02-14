select
    a.platform                                                 as platform
    , a.venue                                                  as venue
    , a.order_current_order_status                             as order_status
    , case a.current_allocation_status
        when 0 then 'Accepted'
        when 1 then 'Block level reject'
        when 2 then 'Account level reject'
        when 3 then 'Received'
        when 4 then 'Incomplete'
        when 5 then 'Rejected by intermediary'
        when 6 then 'Allocation pending'
        when 7 then 'Reversed'
        when 8 then 'Cancelled by intermediary'
        when 9 then 'Claimed'
        when 10 then 'Refused'
        when 11 then 'Pending give-up approval'
        when 12 then 'Cancelled'
        when 13 then 'Pending take-up approval'
        when 14 then 'Reversal pending'
        else 'Unknown'
    end::text(200)                                             as allocation_status
    , a.order_trade_date                                       as trade_date
    , a.transaction_time                                       as trade_executed_at
    , a.order_client_order_id                                  as order_id
    , a.member_original_client_order_id                        as order_id_account
    , a.order_block_id                                         as block_id
    , a.alloc_id                                               as allocation_id
    , a.member_indiv_alloc_id                                  as allocation_id_account

    , acc.custodian                                            as custodian
    , a.target_comp_id                                         as broker_name
    , case
        when lower(a.target_comp_id) != lower(acc.custodian)
            then 1
        else 0
    end::int                                                   as is_trade_away
    , a.member_account                                         as account_number

    , a.order_asset_class                                      as asset_class
    , a.order_symbol                                           as ticker
    , a.member_original_order_qty                              as quantity
    , a.member_price                                           as price
    , a.member_avg_price                                       as average_price
    , a.member_net_money                                       as net_amount

    , case
        when a.side = 1
            then 'BUY'
        when a.side = 2
            then 'SELL'
    end::text(200)                                             as order_side
    -- Is this the id for order effect?
    , a.order_type                                             as order_effect

    , a.member_principal::decimal(18 , 2)                      as principal
    , a.member_comm::decimal(18 , 2)                           as commission
    , a.member_accrued_interest_amount::decimal(18 , 2)        as interest
    , (a.member_sec_fee + a.member_other_fee)::decimal(18 , 2) as fees

    , a.order_trader_name                                      as created_by

    , a._created_at                                            as last_collected_at
    --, a._source_file                                           as _source_file

    , object_construct(a.*)                                    as _extra_fields
from {{ ref('flyer__stg_orders_allocations') }} as a
left join {{ ref('flyer__stg_accounts') }} as acc
    on a.member_account = acc.account_number
    and a.order_trade_date = acc._created_at::date
    and a._env = acc._env
where 1 = 1
    and a.is_head = 1
    -- Exclude unfilled orders
    --and coalesce(a.member_net_money,0) <> 0
    and a._env = {{ "'" ~ flyer_env() ~ "'" }}
