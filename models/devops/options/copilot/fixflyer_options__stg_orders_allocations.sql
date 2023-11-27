with cte_max_per_day as (
    select
        _uri
        , to_date(json:tradingSessionId::text , 'YYYYMMDD') as trading_session_date
        , max(_created_at)                                  as max_created_at
    from {{ source('copilot', 'allocations') }}
    group by 1 , 2
)

select
    a.json:allocId::text(200)                                                           as alloc_id
    , a.json:userId::text(200)                                                          as user_id
    , a.json:tradingSessionId::text(200)                                                as trading_session_id
    , a.json:clientOrderId::text(200)                                                   as client_order_id
    , a.json:origClientOrderId::text(200)                                               as original_client_order_id
    , a.json:allocTransType::text(200)                                                  as transaction_type
    , a.json:symbol::text(200)                                                          as symbol
    , a.json:shares::number(19 , 6)                                                     as shares
    , a.json:avgPx::number(19 , 6)                                                      as average_price
    , a.json:noOrders::int                                                              as number_of_orders
    , a.json:noExecs::int                                                               as number_of_executions
    , a.json:side::text(200)                                                            as side
    , a.json:securityId::text(200)                                                      as security_id
    , a.json:securityIdSrc::text(200)                                                   as security_id_src
    , a.json:netMoney::text(200)                                                        as net_money
    , a.json:totNoAllocs::int                                                           as total_number_of_allocations
    , a.json:noAllocs::int                                                              as number_of_allocations
    , a.json:currentAllocStatus::text(200)                                              as current_allocation_status
    , a.json:orderQty::number(19 , 6)                                                   as order_qauntity
    , a.json:accruedInterestRate::number(19 , 6)                                        as accrued_interest_rate
    , a.json:custId::text(200)                                                          as cust_id
    , a.json:userName::text(200)                                                        as user_name
    , a.json:allocationMethod::text(200)                                                as method
    , a.json:beginString::text(200)                                                     as begin_string
    , a.json:onBehalfOfCompID::text(200)                                                as on_behalf_of_comp_id
    , a.json:onBehalfOfSubID::text(200)                                                 as on_behalf_of_sub_id
    , a.json:targetCompId::text(200)                                                    as target_comp_id
    , a.json:senderCompId::text(200)                                                    as sender_comp_id
    , a.json:messageType::text(200)                                                     as message_type
    , a.json:messageSequenceNo::text(200)                                               as message_sequence_no
    , m.value:allocId::text(200)                                                        as member_alloc_id
    , m.value:indivAllocId::text(200)                                                   as member_indiv_alloc_id

    -- MEMBERS
    , m.value:tradingSessionId::text(200)                                               as member_trading_session_id
    , m.value:userId::text(200)                                                         as member_user_id
    , m.value:creatorId::text(200)                                                      as member_creator_id
    , m.value:creatorName::text(200)                                                    as member_creator_name
    , m.value:allocPrice::number(19 , 6)                                                as member_price
    , m.value:allocQty::number(19 , 6)                                                  as member_quantity
    , m.value:allocAvgPx::number(19 , 6)                                                as member_avg_price
    , m.value:allocNetMoney::number(19 , 6)                                             as member_net_money
    , m.value:allocAmount::number(19 , 6)                                               as member_amount
    , m.value:allocAccount::text(200)                                                   as member_account
    , m.value:originalOrderQty::number(19 , 6)                                          as member_original_order_qty
    , m.value:originalClientOrderId::text(200)                                          as member_original_client_order_id
    , m.value:secFee::number(19 , 6)                                                    as member_sec_fee
    , m.value:otherFee::number(19 , 6)                                                  as member_other_fee
    , m.value:settlementType::text(200)                                                 as member_settlement_type
    , m.value:accruedInterestAmount::number(19 , 6)                                     as member_accrued_interest_amount
    , m.value:purchasePrice::number(19 , 6)                                             as member_purchase_price
    , m.value:principal::number(19 , 6)                                                 as member_principal
    , m.value:comm::number(19 , 6)                                                      as member_comm
    , m.value:commType::text(200)                                                       as member_comm_type
    , m.value:allocAccountName::text(200)                                               as member_account_name
    , m.value:lotId::text(200)                                                          as member_lot_id
    , a.json:order.blockId::text(200)                                                   as order_block_id
    , a.json:order.aggregatedClientOrderId::text(200)                                   as order_aggregated_client_order_id

    -- ORDERS
    , a.json:order.sleeveId::text(200)                                                  as order_sleeve_id
    , a.json:order.creatorId::text(200)                                                 as order_creator_id
    , a.json:order.creatorName::text(200)                                               as order_creator_name
    , a.json:order.indivCount::number(19 , 6)                                           as order_indiv_count
    , a.json:order.autoSliceStatus::text(200)                                           as order_auto_slice_status
    , a.json:order.clientOrderId::text(200)                                             as order_client_order_id
    , a.json:order.userId::text(200)                                                    as order_user_id
    , a.json:order.tradingSessionId::text(200)                                          as order_trading_session_id
    , a.json:order.custId::text(200)                                                    as order_cust_id
    , a.json:order.userName::text(200)                                                  as order_user_name
    , a.json:order.traderId::text(200)                                                  as order_trader_id
    , a.json:order.traderName::text(200)                                                as order_trader_name
    , a.json:order.custodialAccount::text(200)                                          as order_custodial_account
    , a.json:order.symbol::text(200)                                                    as order_symbol
    , a.json:order.side::text(200)                                                      as order_side
    , a.json:order.timeInForce::text(200)                                               as order_time_in_force
    , a.json:order.execInst::text(200)                                                  as order_exec_inst
    , a.json:order.orderType::text(200)                                                 as order_type
    , a.json:order.price::number(19 , 6)                                                as order_price
    , a.json:order.orderQty::number(19 , 6)                                             as order_order_qty
    , a.json:order.account::text(200)                                                   as order_account
    , a.json:order.stopPx::number(19 , 6)                                               as order_stop_price
    , a.json:order.handlInst::text(200)                                                 as order_handl_inst
    , a.json:order.expireTime::text(200)                                                as order_expire_time
    , a.json:order.commission::number(19 , 6)                                           as order_commission
    , a.json:order.maxFloor::number(19 , 6)                                             as order_max_floor
    , a.json:order.ratioQty::number(19 , 6)                                             as order_ratio_qty
    , a.json:order.noLegs::text(200)                                                    as order_no_legs
    , a.json:order.avgPx::number(19 , 6)                                                as order_avg_price
    , a.json:order.fillQty::number(19 , 6)                                              as order_fill_qty
    , a.json:order.beginString::text(200)                                               as order_begin_string
    , a.json:order.targetCompId::text(200)                                              as order_target_comp_id
    , a.json:order.senderCompId::text(200)                                              as order_sender_comp_id
    , a.json:order.messageType::text(200)                                               as order_message_type
    , a.json:order.onBehalfOfCompID::text(200)                                          as order_on_behalf_of_compid
    , a.json:order.onBehalfOfSubID::text(200)                                           as order_on_behalf_of_sub_id
    , try_to_boolean(a.json:order.validSymbol::text)::int                               as order_is_valid_symbol
    , a.json:order.assetClass::text(200)                                                as order_asset_class
    , try_to_boolean(a.json:order.restageFlag::text)::int                               as order_has_restage_flag
    , a.json:order.currentOrderStatus::text(200)                                        as order_current_order_status
    , a.json:order.submittedBy::text(200)                                               as order_submitted_by
    , a.json:order.option.clientOrdId::text(200)                                        as order_option_client_ord_id
    , a.json:order.option.tradingSessionId::text(200)                                   as order_option_trading_session_id
    , a.json:order.option.userId::text(200)                                             as order_option_user_id
    , a.json:order.option.strikePrice::number(19 , 6)                                   as order_option_strike_price
    , a.json:order.option.putOrCall::text(200)                                          as order_option_put_or_call
    , a.json:order.option.positionEffect::text(200)                                     as order_option_position_effect
    , a.json:order.option.customerOrFirm::text(200)                                     as order_option_customer_or_firm
    , a.json:order.mutualFund.clientOrdId::text(200)                                    as order_mutualfund_client_or_did
    , a.json:order.mutualFund.tradingSessionId::text(200)                               as order_mutualfund_trading_session_id
    , a.json:order.mutualFund.userId::text(200)                                         as order_mutualfund_user_id
    , a.json:order.mutualFund.state::text(200)                                          as order_mutualfund_state
    , a.json:order.mutualFund.amount::number(19 , 6)                                    as order_mutualfund_amount
    , a.json:order.mutualFund.round::text(200)                                          as order_mutualfund_round
    , a.json:order.mutualFund.dividend::text(200)                                       as order_mutualfund_dividend
    , a.json:order.mutualFund.longTermGain::text(200)                                   as order_mutualfund_long_term_gain
    , a.json:order.mutualFund.shortTermGain::text(200)                                  as order_mutualfund_short_term_gain
    , a.json:order.mutualFund.initialOrFull::text(200)                                  as order_mutualfund_initial_or_full
    , try_to_boolean(a.json:order.mutualFund.feeIndicator::text)::int                   as order_has_mutualfund_fee_indicator
    , a.json:order.mutualFund.linkQtyPercent::number(19 , 6)                            as order_mutualfund_link_qty_percent
    , a.json:order.mutualFund.linkAmount::number(19 , 6)                                as order_mutualfund_link_amount
    , a.json:order.fixedIncome.clientOrderId::text(200)                                 as order_fixedincome_client_order_id
    , a.json:order.fixedIncome.tradingSessionId::text(200)                              as order_fixedincome_trading_session_id
    , a.json:order.fixedIncome.userId::text(200)                                        as order_fixedincome_user_id
    , a.json:order.fixedIncome.couponRate::number(19 , 6)                               as order_fixedincome_coupon_rate
    , a.json:order.fixedIncome.securityDesc::text(200)                                  as order_fixedincome_security_desc
    , a.json:order.fixedIncome.priceType::text(200)                                     as order_fixedincome_price_type
    , a.json:order.fixedIncome.accruedInterestAmt::number(19 , 6)
        as order_fixedincome_accrued_interest_amt
    , a.json:order.fixedIncome.factor::number(19 , 6)                                   as order_fixedincome_factor
    , a.json:order.fixedIncome.product::number(19 , 6)                                  as order_fixedincome_product
    , a.json:order.fixedIncome.yield::number(19 , 6)                                    as order_fixedincome_yield
    , a.json:order.fixedIncome.originalFace::number(19 , 6)                             as order_fixedincome_originalface
    , a.json:order.fixedIncome.principal::number(19 , 6)                                as order_fixedincome_principal
    , case
        when a._created_at = mxpd.max_created_at
            then 1
        else 0
    end::int                                                                            as is_head
    , dt.prior_market_date                                                              as effective_date
    , a._created_at                                                                     as _created_at
    , a._source_file                                                                    as _source_file
    , a._uri                                                                            as _uri
    , to_date(a.json:tradeDate::varchar(100) , 'YYYYMMDD')                              as trade_date
    , to_timestamp(a.json:transactTime::varchar(100) , 'YYYYMMDD-HH24:MI:SS.FF3')       as transaction_time
    , to_date(a.json:order.tradeDate::varchar(100) , 'YYYYMMDD')                        as order_trade_date
    , to_timestamp(a.json:order.transactTime::varchar(100) , 'YYYYMMDD-HH24:MI:SS.FF3') as order_transaction_time
    , to_date(a.json:order.option.maturityDate::varchar(100) , 'YYYYMMDD')              as order_option_maturity_date
    , to_date(a.json:tradingSessionId::text , 'YYYYMMDD')                               as trading_session_date
    , nullif(a.json:clientOrderId::text(200) , '')                                      as client_order_id

    , to_date(a.json:tradeDate::varchar(100) , 'YYYYMMDD')                              as trade_date
    , to_timestamp(a.json:transactTime::varchar(100) , 'YYYYMMDD-HH24:MI:SS.FF3')       as transaction_time
    , to_date(a.json:order.tradeDate::varchar(100) , 'YYYYMMDD')                        as order_trade_date
    , to_timestamp(a.json:order.transactTime::varchar(100) , 'YYYYMMDD-HH24:MI:SS.FF3') as order_transaction_time
    , to_date(a.json:order.option.maturityDate::varchar(100) , 'YYYYMMDD')              as order_option_maturity_date
    , {{ parse_flyer_env(col='a._uri') }}
from {{ source('copilot', 'allocations') }} as a
left join cte_max_per_day as mxpd
    on a._uri = mxpd._uri
    and to_date(a.json:tradingSessionId::text , 'YYYYMMDD') = mxpd.trading_session_date
left join {{ ref('dates' ) }} as dt
    on to_date(a.json:tradingSessionId::text , 'YYYYMMDD') = dt.date_key
, lateral flatten(input => a.json , path => 'memberList' , outer => true , mode => 'array') as m
, lateral flatten(input => a.json , path => 'order' , outer => true , mode => 'array')
where 1 = 1
