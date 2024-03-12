select
    a.platform                                                 as platform
    , a.venue                                                  as venue
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
        end::text(200)                                          as order_status
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
    , a.transaction_time::timestamp_tz                         as trade_executed_at
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
    , a.symbol                                                 as ticker
    , a.underlying_symbol                                      as underlying_ticker
    , a.member_original_order_qty                              as order_quantity
    , a.member_quantity                                        as filled_quantity
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

    , a.order_option_maturity_date                             as option_expiration_date
    , a.order_option_strike_price                              as option_strike_price
    , a.order_option_put_or_call                               as option_type

    , a._created_at                                            as last_collected_at
    --, a._source_file                                           as _source_file

    , object_construct(a.*)                                    as _extra_fields
from {{ ref('flyer__stg_orders_allocations') }} as a
left join {{ ref('flyer__stg_accounts') }} as acc
    on a.member_account = acc.account_number
    and a.order_trade_date = acc._created_at::date
    and a._env = acc._env
    and acc.is_head = 1
where 1 = 1
    and a.is_head = 1
    -- Exclude unfilled orders
    --and coalesce(a.member_net_money,0) <> 0
    and a._env = {{ "'" ~ copilot_env() ~ "'" }}

union all

select
    platform
    , venue
    , null::text(200)               as order_status
    , null::text(200)               as allocation_status
    , execution_date                as trade_date
    , execution_at::timestamp_tz    as trade_executed_at
    , source_order_id               as order_id
    , account_number                as order_id_account
    , null::text(200)               as block_id
    , allocation_id                 as allocation_id
    , account_number                as allocation_id_account
    , custodian                     as custodian
    , broker_name                   as broker_name
    , is_trade_away                 as is_trade_away
    , account_number                as account_number
    , source_security_type          as asset_class
    , ticker                        as ticker
    , case
        when source_security_type = 'OPTION'
            then regexp_substr(
                ticker, '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 1
            )
            else null
            end::text(200)          as underlying_ticker
    , null::decimal(20, 5)          as order_quantity
    , units_shares                  as filled_quantity
    , price                         as price
    , null::decimal(20, 5)          as average_price
    , net                           as net_amount
    , buy_sell                      as order_side
    , order_type                    as order_effect
    , principal                     as principal
    , commission                    as commission
    , interest                      as interest
    , null::decimal(20,2)           as fees
    , null::text(200)               as created_by
    , case
        when source_security_type = 'OPTION'
            then try_to_date(regexp_substr(
                ticker, '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 2
            ), 'YYMMDD')
        else null
        end::date                   as option_expiration_date
    , case
        when source_security_type = 'OPTION'
            then (regexp_substr(
                ticker, '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 4
            )::int / 1000)
            else null
            end::decimal(20 , 2)    as option_strike_price
    , case
        when source_security_type = 'OPTION'
            then regexp_substr(
                    ticker, '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)', 1, 1, 'e', 3
                )
            else null
            end::text(200)          as option_type
    , _created_at                   as last_collected_at
    , null::variant                 as _extra_fields
from {{ ref('fourforty__int_orders_allocations') }}
order by trade_date desc, trade_executed_at
