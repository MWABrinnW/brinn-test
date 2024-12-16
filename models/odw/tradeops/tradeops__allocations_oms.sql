-- [Copilot]
select
    a.system_key::text                                         as system_key
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
    end::text                                                  as order_status
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
    end::text                                                  as allocation_status
    , a.order_trade_date::date                                 as trade_date
    , a.transaction_time::timestamp_tz                         as trade_executed_at
    , a.order_client_order_id::text                            as order_id
    , a.member_original_client_order_id::text                  as order_id_account
    , a.order_block_id::text                                   as block_id
    , a.alloc_id::text                                         as allocation_id
    , a.member_indiv_alloc_id::text                            as allocation_id_account

    , acc.custodian::text                                      as custodian
    , a.target_comp_id::text                                   as broker_name
    , case
        when lower(a.target_comp_id) != lower(acc.custodian)
            then 1
        else 0
    end::int                                                   as is_trade_away
    , a.member_account::text                                   as account_number
    , null::text                                               as account_id

    , a.order_asset_class::text                                as asset_class
    , a.symbol::text                                           as symbol
    , a.symbol::text                                           as ticker
    , null::text                                               as cusip
    , a.underlying_symbol::text                                as underlying_ticker
    , a.member_original_order_qty::decimal(20 , 5)             as order_quantity
    , a.member_quantity::decimal(20 , 5)                       as filled_quantity
    , a.member_price::decimal(20 , 5)                          as price
    , a.member_avg_price::decimal(20 , 5)                      as average_price
    , a.member_net_money::decimal(20 , 2)                      as net_amount

    , case
        when a.side = 1
            then 'BUY'
        when a.side = 2
            then 'SELL'
    end::text                                                  as order_side
    -- Is this the id for order effect?
    , a.order_type::text                                       as order_effect

    , a.member_principal::decimal(20 , 2)                      as principal
    , a.member_comm::decimal(20 , 2)                           as commission
    , a.member_accrued_interest_amount::decimal(20 , 2)        as interest
    , (a.member_sec_fee + a.member_other_fee)::decimal(20 , 2) as fees

    , a.order_trader_name::text                                as created_by

    , a.order_option_maturity_date::date                       as option_expiration_date
    , a.order_option_strike_price::decimal(20 , 5)             as option_strike_price
    , a.order_option_put_or_call::text                         as option_type

    , a._created_at::timestamp_ntz                             as _created_at
    , a.system_name::text                                      as system_name
    , a.system_instance::text                                  as system_instance

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


-- [FourForty]
union all

select
    system_key::text                as system_key
    , null::text(200)               as order_status
    , null::text(200)               as allocation_status
    , execution_date::date          as trade_date
    , execution_at::timestamp_tz    as trade_executed_at
    , source_order_id::text         as order_id
    , account_number::text          as order_id_account
    , null::text                    as block_id
    , allocation_id::text           as allocation_id
    , account_number::text          as allocation_id_account
    , custodian::text               as custodian
    , broker_name::text             as broker_name
    , is_trade_away::int            as is_trade_away
    , account_number::text          as account_number
    , null::text                    as account_id
    , source_security_type::text    as asset_class
    , ticker::text                  as symbol
    , ticker::text                  as ticker
    , null::text                    as cusip
    , case
        when source_security_type = 'OPTION'
            then regexp_substr(
                    ticker , '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)' , 1 , 1 , 'e' , 1
                )
    end::text                       as underlying_ticker
    , null::decimal(20 , 5)         as order_quantity
    , units_shares::decimal(20 , 5) as filled_quantity
    , price::decimal(20 , 5)        as price
    , null::decimal(20 , 5)         as average_price
    , net::decimal(20 , 2)          as net_amount
    , buy_sell::text                as order_side
    , order_type::text              as order_effect
    , principal::decimal(20 , 2)    as principal
    , commission::decimal(20 , 2)   as commission
    , interest::decimal(20 , 2)     as interest
    , null::decimal(20 , 2)         as fees
    , null::text                    as created_by
    , case
        when source_security_type = 'OPTION'
            then try_to_date(regexp_substr(
                    ticker , '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)' , 1 , 1 , 'e' , 2
                ) , 'YYMMDD')
    end::date                       as option_expiration_date
    , case
        when source_security_type = 'OPTION'
            then (regexp_substr(
                ticker , '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)' , 1 , 1 , 'e' , 4
            )::int / 1000)
    end::decimal(20 , 2)            as option_strike_price
    , case
        when source_security_type = 'OPTION'
            then regexp_substr(
                    ticker , '^(\\D+)(\\d{6,7})(C|P)(\\d+(\\.\\d+)?)' , 1 , 1 , 'e' , 3
                )
    end::text(200)                  as option_type
    , _created_at::timestamp_ntz    as _created_at
    , system_name::text             as system_name
    , system_instance::text         as system_instance
    , null::variant                 as _extra_fields
from {{ ref('fourforty__int_orders_allocations') }}

-- [Perform]
union all

select
    a.system_key::text              as system_key
    -- Not in source.
    , null::text                    as order_status
    -- Not in source.
    , null::text                    as allocation_status
    , a.trade_date                  as trade_date
    , a.traded_at                   as trade_executed_at
    , a.order_id::text              as order_id
    , null::text                    as order_id_account
    , null::text                    as block_id
    , null::text                    as allocation_id
    , concat_ws(
        '_'
        , a.trade_date , a.account_number , a.cusip , a.order_id
    )                               as allocation_id_account
    , lower(a.custodian)            as custodian
    , a.broker_name::text           as broker_name
    , a.trade_away::int             as is_trade_away
    , a.account_number::text        as account_number
    , a.portfolio_id::text          as account_id
    , a.source_security_type::text  as asset_class
    , a.cusip::text                 as symbol
    , null::text                    as ticker
    , a.cusip::text                 as cusip
    , null::text                    as underlying_ticker
    , a.units::decimal(20 , 5)      as order_quantity
    , a.units::decimal(20 , 5)      as filled_quantity
    , a.unit_price::decimal(20 , 5) as price
    , a.unit_price::decimal(20 , 5) as average_price
    , a.net::decimal(20 , 2)        as net_amount
    , upper(a.order_side)           as order_side
    , a.order_effect::text          as order_effect
    , a.principal::decimal(20 , 2)  as principal
    , null::decimal(20 , 2)         as commission
    , a.interest::decimal(20 , 2)   as interest
    , null::decimal(20 , 2)         as fees
    , a.trader::text                as created_by
    , null::date                    as option_expiration_date
    , null::decimal(20 , 2)         as option_strike_price
    , null::text                    as option_type
    , a._created_at::timestamp_ntz  as _created_at
    , a.system_name::text           as system_name
    , a.system_instance::text       as system_instance
    , null::variant                 as _extra_fields
from {{ ref('perform__fct_allocations') }} as a
where 1 = 1

-- [Moxy]
union all

select
    a.system_key::text             as system_key
    -- Not in source.
    , null::text                   as order_status
    -- Not in source.
    , null::text                   as allocation_status
    , a.trade_date                 as trade_date
    , a.traded_at                  as trade_executed_at
    , a.order_id::text             as order_id
    , null::text                   as order_id_account
    , null::text                   as block_id
    , a.allocation_id::text        as allocation_id
    , concat_ws(
        '_'
        , a.trade_date , a.account_number , a.cusip , a.order_id
    )                              as allocation_id_account
    , lower(a.custodian)::text     as custodian
    , a.broker_name::text          as broker_name
    , a.trade_away::int            as is_trade_away
    , a.account_number::text       as account_number
    , a.portfolio_id::text         as account_id
    , a.source_security_type::text as asset_class
    , a.symbol::text               as symbol
    , a.symbol::text               as ticker
    , a.cusip::text                as ticker
    , null::text                   as underlying_ticker
    , a.quantity::decimal(20 , 5)  as order_quantity
    , a.quantity::decimal(20 , 5)  as filled_quantity
    , a.price::decimal(20 , 5)     as price
    , a.price::decimal(20 , 5)     as average_price
    , a.net::decimal(20 , 2)       as net_amount
    , upper(a.order_side)          as order_side
    , a.order_effect::text         as order_effect
    , a.principal::decimal(20 , 2) as principal
    , null::decimal(20 , 2)        as commission
    , a.interest::decimal(20 , 2)  as interest
    , null::decimal(20 , 2)        as fees
    , a.trader::text               as created_by
    , null::date                   as option_expiration_date
    , null::decimal(20 , 2)        as option_strike_price
    , null::text                   as option_type
    , a._created_at::timestamp_ntz as _created_at
    , a.system_name::text          as system_name
    , a.system_instance::text      as system_instance
    , null::variant                as _extra_fields
from {{ ref('moxy__fct_allocations') }} as a
