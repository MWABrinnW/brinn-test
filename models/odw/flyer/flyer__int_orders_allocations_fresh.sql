with fresh_dates as (
    select
        trading_session_date as trading_session_date
        , max(_created_at)   as max_created_at
    from {{ source('flyer', 'allocations') }}
    where 1 = 1
        and _created_at > (select max(_source_loaded_at) from {{ ref('flyer__int_orders_allocations_history') }})
    group by all
)

select
    a.system_name                              as system_name
    , a.system_instance                        as system_instance
    , a.system_key                             as system_key
    , a.alloc_id                               as alloc_id
    , a.user_id                                as user_id
    , a.trading_session_id                     as trading_session_id
    , a.trading_session_date                   as trading_session_date
    , a.client_order_id                        as client_order_id
    , a.original_client_order_id               as original_client_order_id
    , a.transaction_type                       as transaction_type
    , a.security_type                          as security_type
    , a.is_option                              as is_option
    , a.order_option_maturity_date             as order_option_maturity_date
    , a.order_option_strike_price              as order_option_strike_price
    , a.order_option_put_or_call               as order_option_put_or_call
    , a.order_option_position_effect           as order_option_position_effect
    , a.symbol                                 as symbol
    , a.underlying_symbol                      as underlying_symbol
    , a.shares                                 as shares
    , a.average_price                          as average_price
    , a.number_of_orders                       as number_of_orders
    , a.number_of_executions                   as number_of_executions
    , a.side                                   as side
    , a.security_id                            as security_id
    , a.security_id_src                        as security_id_src
    , a.net_money                              as net_money
    , a.total_number_of_allocations            as total_number_of_allocations
    , a.number_of_allocations                  as number_of_allocations
    , a.current_allocation_status              as current_allocation_status
    , a.order_quantity                         as order_quantity
    , a.accrued_interest_rate                  as accrued_interest_rate
    , a.cust_id                                as cust_id
    , a.user_name                              as user_name
    , a.method                                 as method
    , a.begin_string                           as begin_string
    , a.on_behalf_of_comp_id                   as on_behalf_of_comp_id
    , a.on_behalf_of_sub_id                    as on_behalf_of_sub_id
    , a.target_comp_id                         as target_comp_id
    , a.sender_comp_id                         as sender_comp_id
    , a.message_type                           as message_type
    , a.message_sequence_no                    as message_sequence_no
    , a.member_alloc_id                        as member_alloc_id
    , a.member_indiv_alloc_id                  as member_indiv_alloc_id
    , a.member_trading_session_id              as member_trading_session_id
    , a.member_user_id                         as member_user_id
    , a.member_creator_id                      as member_creator_id
    , a.member_creator_name                    as member_creator_name
    , a.member_price                           as member_price
    , a.member_quantity                        as member_quantity
    , a.member_avg_price                       as member_avg_price
    , a.member_net_money                       as member_net_money
    , a.member_amount                          as member_amount
    , a.member_account                         as member_account
    , a.member_original_order_qty              as member_original_order_qty
    , a.member_original_client_order_id        as member_original_client_order_id
    , a.member_sec_fee                         as member_sec_fee
    , a.member_other_fee                       as member_other_fee
    , a.member_settlement_type                 as member_settlement_type
    , a.member_accrued_interest_amount         as member_accrued_interest_amount
    , a.member_purchase_price                  as member_purchase_price
    , a.member_principal                       as member_principal
    , a.member_comm                            as member_comm
    , a.member_comm_type                       as member_comm_type
    , a.member_account_name                    as member_account_name
    , a.member_lot_id                          as member_lot_id
    , a.order_block_id                         as order_block_id
    , a.order_aggregated_client_order_id       as order_aggregated_client_order_id
    , a.order_sleeve_id                        as order_sleeve_id
    , a.order_creator_id                       as order_creator_id
    , a.order_creator_name                     as order_creator_name
    , a.order_indiv_count                      as order_indiv_count
    , a.order_auto_slice_status                as order_auto_slice_status
    , a.order_client_order_id                  as order_client_order_id
    , a.order_user_id                          as order_user_id
    , a.order_trading_session_id               as order_trading_session_id
    , a.order_cust_id                          as order_cust_id
    , a.order_user_name                        as order_user_name
    , a.order_trader_id                        as order_trader_id
    , a.order_trader_name                      as order_trader_name
    , a.order_custodial_account                as order_custodial_account
    , a.order_symbol                           as order_symbol
    , a.order_side                             as order_side
    , a.order_time_in_force                    as order_time_in_force
    , a.order_exec_inst                        as order_exec_inst
    , a.order_type                             as order_type
    , a.order_price                            as order_price
    , a.order_order_qty                        as order_order_qty
    , a.order_account                          as order_account
    , a.order_stop_price                       as order_stop_price
    , a.order_handl_inst                       as order_handl_inst
    , a.order_expire_time                      as order_expire_time
    , a.order_commission                       as order_commission
    , a.order_max_floor                        as order_max_floor
    , a.order_ratio_qty                        as order_ratio_qty
    , a.order_security_type                    as order_security_type
    , a.order_no_legs                          as order_no_legs
    , a.order_avg_price                        as order_avg_price
    , a.order_fill_qty                         as order_fill_qty
    , a.order_begin_string                     as order_begin_string
    , a.order_target_comp_id                   as order_target_comp_id
    , a.order_sender_comp_id                   as order_sender_comp_id
    , a.order_message_type                     as order_message_type
    , a.order_on_behalf_of_compid              as order_on_behalf_of_compid
    , a.order_on_behalf_of_sub_id              as order_on_behalf_of_sub_id
    , a.order_is_valid_symbol                  as order_is_valid_symbol
    , a.order_asset_class                      as order_asset_class
    , a.order_has_restage_flag                 as order_has_restage_flag
    , a.order_current_order_status             as order_current_order_status
    , a.order_submitted_by                     as order_submitted_by
    , a.order_option_client_ord_id             as order_option_client_ord_id
    , a.order_option_trading_session_id        as order_option_trading_session_id
    , a.order_option_user_id                   as order_option_user_id
    , a.order_option_customer_or_firm          as order_option_customer_or_firm
    , a.order_mutualfund_client_or_did         as order_mutualfund_client_or_did
    , a.order_mutualfund_trading_session_id    as order_mutualfund_trading_session_id
    , a.order_mutualfund_user_id               as order_mutualfund_user_id
    , a.order_mutualfund_state                 as order_mutualfund_state
    , a.order_mutualfund_amount                as order_mutualfund_amount
    , a.order_mutualfund_round                 as order_mutualfund_round
    , a.order_mutualfund_dividend              as order_mutualfund_dividend
    , a.order_mutualfund_long_term_gain        as order_mutualfund_long_term_gain
    , a.order_mutualfund_short_term_gain       as order_mutualfund_short_term_gain
    , a.order_mutualfund_initial_or_full       as order_mutualfund_initial_or_full
    , a.order_has_mutualfund_fee_indicator     as order_has_mutualfund_fee_indicator
    , a.order_mutualfund_link_qty_percent      as order_mutualfund_link_qty_percent
    , a.order_mutualfund_link_amount           as order_mutualfund_link_amount
    , a.order_fixedincome_client_order_id      as order_fixedincome_client_order_id
    , a.order_fixedincome_trading_session_id   as order_fixedincome_trading_session_id
    , a.order_fixedincome_user_id              as order_fixedincome_user_id
    , a.order_fixedincome_coupon_rate          as order_fixedincome_coupon_rate
    , a.order_fixedincome_security_desc        as order_fixedincome_security_desc
    , a.order_fixedincome_price_type           as order_fixedincome_price_type
    , a.order_fixedincome_accrued_interest_amt as order_fixedincome_accrued_interest_amt
    , a.order_fixedincome_factor               as order_fixedincome_factor
    , a.order_fixedincome_product              as order_fixedincome_product
    , a.order_fixedincome_yield                as order_fixedincome_yield
    , a.order_fixedincome_originalface         as order_fixedincome_originalface
    , a.order_fixedincome_principal            as order_fixedincome_principal
    , a.option_ticker                          as option_ticker
    , a.option_ex_date                         as option_ex_date
    , a.option_type                            as option_type
    , a.option_strike_price                    as option_strike_price
    , a.option_symbol                          as option_symbol
    , a.option_symbol_occ                      as option_symbol_occ
    , a.effective_date                         as effective_date
    , a._source_file                           as _source_file
    , a._uri                                   as _uri
    , a.trade_date                             as trade_date
    , a.order_trade_date                       as order_trade_date
    , a.transaction_time                       as transaction_time
    , a.order_transaction_time                 as order_transaction_time

    , current_timestamp()::timestamp_ntz       as _created_at
    , a._created_at                            as _source_loaded_at
from {{ ref('flyer__stg_orders_allocations') }} as a
where 1 = 1
    and exists (select 1 from fresh_dates)
    and a.trading_session_date in (select distinct trading_session_date from fresh_dates)
-- We pull allocations multiple times throughout the day and we only want to keep the latest
-- understanding for each trading date.
qualify dense_rank() over (
        partition by a.trading_session_date
        order by a._created_at desc
    ) = 1
