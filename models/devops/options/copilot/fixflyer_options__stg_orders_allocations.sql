select
    alloc.json:allocId::text(200)                                                        as alloc_id
  , alloc.json:userId::text(200)                                                         as user_id
  , alloc.json:tradingSessionId::text(200)                                               as trading_session_id
  , alloc.json:clientOrderId::text(200)                                                  as client_order_id
  , alloc.json:origClientOrderId::text(200)                                              as original_client_order_id
  , alloc.json:allocTransType::text(200)                                                 as transaction_type
  , alloc.json:symbol::text(200)                                                         as symbol
  , alloc.json:shares::number(19, 6)                                                     as shares
  , alloc.json:avgPx::number(19, 6)                                                      as average_price
  , alloc.json:noOrders::int                                                             as number_of_orders
  , alloc.json:noExecs::int                                                              as number_of_executions
  , alloc.json:side::text(200)                                                           as side
  , alloc.json:securityId::text(200)                                                     as security_id
  , alloc.json:securityIdSrc::text(200)                                                  as security_id_src
  , to_date(alloc.json:tradeDate::varchar(100), 'YYYYMMDD')                              as trade_date
  , to_timestamp(alloc.json:transactTime::varchar(100), 'YYYYMMDD-HH24:MI:SS.FF3')       as transaction_time
  , alloc.json:netMoney::text(200)                                                       as net_money
  , alloc.json:totNoAllocs::int                                                          as total_number_of_allocations
  , alloc.json:noAllocs::int                                                             as number_of_allocations
  , alloc.json:currentAllocStatus::text(200)                                             as current_allocation_status
  , alloc.json:orderQty::number(19, 6)                                                   as order_qauntity
  , alloc.json:accruedInterestRate::number(19, 6)                                        as accrued_interest_rate
  , alloc.json:custId::text(200)                                                         as cust_id
  , alloc.json:userName::text(200)                                                       as user_name
  , alloc.json:allocationMethod::text(200)                                               as method
  , alloc.json:beginString::text(200)                                                    as begin_string
  , alloc.json:onBehalfOfCompID::text(200)                                               as on_behalf_of_comp_id
  , alloc.json:onBehalfOfSubID::text(200)                                                as on_behalf_of_sub_id
  , alloc.json:targetCompId::text(200)                                                   as target_comp_id
  , alloc.json:senderCompId::text(200)                                                   as sender_comp_id
  , alloc.json:messageType::text(200)                                                    as message_type
  , alloc.json:messageSequenceNo::text(200)                                              as message_sequence_no

  -- MEMBERS
  , m.value:allocId::text(200)                                                           as member_alloc_id
  , m.value:indivAllocId::text(200)                                                      as member_indiv_alloc_id
  , m.value:tradingSessionId::text(200)                                                  as member_trading_session_id
  , m.value:userId::text(200)                                                            as member_user_id
  , m.value:creatorId::text(200)                                                         as member_creator_id
  , m.value:creatorName::text(200)                                                       as member_creator_name
  , m.value:allocPrice::number(19, 6)                                                    as member_price
  , m.value:allocQty::number(19, 6)                                                      as member_quantity
  , m.value:allocAvgPx::number(19, 6)                                                    as member_avg_price
  , m.value:allocNetMoney::number(19, 6)                                                 as member_net_money
  , m.value:allocAmount::number(19, 6)                                                   as member_amount
  , m.value:allocAccount::text(200)                                                      as member_account
  , m.value:originalOrderQty::number(19, 6)                                              as member_original_order_qty
  , m.value:originalClientOrderId::text(200)                                             as member_original_client_order_id
  , m.value:secFee::number(19, 6)                                                        as member_sec_fee
  , m.value:otherFee::number(19, 6)                                                      as member_other_fee
  , m.value:settlementType::text(200)                                                    as member_settlement_type
  , m.value:accruedInterestAmount::number(19, 6)                                         as member_accrued_interest_amount
  , m.value:purchasePrice::number(19, 6)                                                 as member_purchase_price
  , m.value:principal::number(19, 6)                                                     as member_principal
  , m.value:comm::number(19, 6)                                                          as member_comm
  , m.value:commType::text(200)                                                          as member_comm_type
  , m.value:allocAccountName::text(200)                                                  as member_account_name
  , m.value:lotId::text(200)                                                             as member_lot_id

  -- ORDERS
  , alloc.json:order.blockId::text(200)                                                  as order_block_id
  , alloc.json:order.aggregatedClientOrderId::text(200)                                  as order_aggregated_client_order_id
  , alloc.json:order.sleeveId::text(200)                                                 as order_sleeve_id
  , alloc.json:order.creatorId::text(200)                                                as order_creator_id
  , alloc.json:order.creatorName::text(200)                                              as order_creator_name
  , alloc.json:order.indivCount::number(19, 6)                                           as order_indiv_count
  , alloc.json:order.autoSliceStatus::text(200)                                          as order_auto_slice_status
  , alloc.json:order.clientOrderId::text(200)                                            as order_client_order_id
  , alloc.json:order.userId::text(200)                                                   as order_user_id
  , alloc.json:order.tradingSessionId::text(200)                                         as order_trading_session_id
  , alloc.json:order.custId::text(200)                                                   as order_cust_id
  , alloc.json:order.userName::text(200)                                                 as order_user_name
  , alloc.json:order.traderId::text(200)                                                 as order_trader_id
  , alloc.json:order.traderName::text(200)                                               as order_trader_name
  , alloc.json:order.custodialAccount::text(200)                                         as order_custodial_account
  , alloc.json:order.symbol::text(200)                                                   as order_symbol
  , alloc.json:order.side::text(200)                                                     as order_side
  , to_date(alloc.json:order.tradeDate::varchar(100), 'YYYYMMDD')                        as order_trade_date
  , alloc.json:order.timeInForce::text(200)                                              as order_time_in_force
  , alloc.json:order.execInst::text(200)                                                 as order_exec_inst
  , alloc.json:order.orderType::text(200)                                                as order_type
  , alloc.json:order.price::number(19, 6)                                                as order_price
  , alloc.json:order.orderQty::number(19, 6)                                             as order_order_qty
  , to_timestamp(alloc.json:order.transactTime::varchar(100), 'YYYYMMDD-HH24:MI:SS.FF3') as order_transaction_time
  , alloc.json:order.account::text(200)                                                  as order_account
  , alloc.json:order.stopPx::number(19, 6)                                               as order_stop_price
  , alloc.json:order.handlInst::text(200)                                                as order_handl_inst
  , alloc.json:order.expireTime::text(200)                                               as order_expire_time
  , alloc.json:order.commission::number(19, 6)                                           as order_commission
  , alloc.json:order.maxFloor::number(19, 6)                                             as order_max_floor
  , alloc.json:order.ratioQty::number(19, 6)                                             as order_ratio_qty
  , alloc.json:order.noLegs::text(200)                                                   as order_no_legs
  , alloc.json:order.avgPx::number(19, 6)                                                as order_avg_price
  , alloc.json:order.fillQty::number(19, 6)                                              as order_fill_qty
  , alloc.json:order.beginString::text(200)                                              as order_begin_string
  , alloc.json:order.targetCompId::text(200)                                             as order_target_comp_id
  , alloc.json:order.senderCompId::text(200)                                             as order_sender_comp_id
  , alloc.json:order.messageType::text(200)                                              as order_message_type
  , alloc.json:order.onBehalfOfCompID::text(200)                                         as order_on_behalf_of_compid
  , alloc.json:order.onBehalfOfSubID::text(200)                                          as order_on_behalf_of_sub_id
  , try_to_boolean(alloc.json:order.validSymbol::text)::int                              as order_is_valid_symbol
  , alloc.json:order.assetClass::text(200)                                               as order_asset_class
  , try_to_boolean(alloc.json:order.restageFlag::text)::int                              as order_has_restage_flag
  , alloc.json:order.currentOrderStatus::text(200)                                       as order_current_order_status
  , alloc.json:order.submittedBy::text(200)                                              as order_submitted_by
  , alloc.json:order.option.clientOrdId::text(200)                                       as order_option_client_ord_id
  , alloc.json:order.option.tradingSessionId::text(200)                                  as order_option_trading_session_id
  , alloc.json:order.option.userId::text(200)                                            as order_option_user_id
  , to_date(alloc.json:order.option.maturityDate::varchar(100), 'YYYYMMDD')              as order_option_maturity_date
  , alloc.json:order.option.strikePrice::number(19, 6)                                   as order_option_strike_price
  , alloc.json:order.option.putOrCall::text(200)                                         as order_option_put_or_call
  , alloc.json:order.option.positionEffect::text(200)                                    as order_option_position_effect
  , alloc.json:order.option.customerOrFirm::text(200)                                    as order_option_customer_or_firm
  , alloc.json:order.mutualFund.clientOrdId::text(200)                                   as order_mutualfund_client_or_did
  , alloc.json:order.mutualFund.tradingSessionId::text(200)                              as order_mutualfund_trading_session_id
  , alloc.json:order.mutualFund.userId::text(200)                                        as order_mutualfund_user_id
  , alloc.json:order.mutualFund.state::text(200)                                         as order_mutualfund_state
  , alloc.json:order.mutualFund.amount::number(19, 6)                                    as order_mutualfund_amount
  , alloc.json:order.mutualFund.round::text(200)                                         as order_mutualfund_round
  , alloc.json:order.mutualFund.dividend::text(200)                                      as order_mutualfund_dividend
  , alloc.json:order.mutualFund.longTermGain::text(200)                                  as order_mutualfund_long_term_gain
  , alloc.json:order.mutualFund.shortTermGain::text(200)                                 as order_mutualfund_short_term_gain
  , alloc.json:order.mutualFund.initialOrFull::text(200)                                 as order_mutualfund_initial_or_full
  , try_to_boolean(alloc.json:order.mutualFund.feeIndicator::text)::int                  as order_has_mutualfund_fee_indicator
  , alloc.json:order.mutualFund.linkQtyPercent::number(19, 6)                            as order_mutualfund_link_qty_percent
  , alloc.json:order.mutualFund.linkAmount::number(19, 6)                                as order_mutualfund_link_amount
  , alloc.json:order.fixedIncome.clientOrderId::text(200)                                as order_fixedincome_client_order_id
  , alloc.json:order.fixedIncome.tradingSessionId::text(200)                             as order_fixedincome_trading_session_id
  , alloc.json:order.fixedIncome.userId::text(200)                                       as order_fixedincome_user_id
  , alloc.json:order.fixedIncome.couponRate::number(19, 6)                               as order_fixedincome_coupon_rate
  , alloc.json:order.fixedIncome.securityDesc::text(200)                                 as order_fixedincome_security_desc
  , alloc.json:order.fixedIncome.priceType::text(200)                                    as order_fixedincome_price_type
  , alloc.json:order.fixedIncome.accruedInterestAmt::number(19, 6)                       as order_fixedincome_accrued_interest_amt
  , alloc.json:order.fixedIncome.factor::number(19, 6)                                   as order_fixedincome_factor
  , alloc.json:order.fixedIncome.product::number(19, 6)                                  as order_fixedincome_product
  , alloc.json:order.fixedIncome.yield::number(19, 6)                                    as order_fixedincome_yield
  , alloc.json:order.fixedIncome.originalFace::number(19, 6)                             as order_fixedincome_originalface
  , alloc.json:order.fixedIncome.principal::number(19, 6)                                as order_fixedincome_principal
  , {{ col_is_head(reference=source('copilot', 'allocations'), source_date_col='alloc._created_at', reference_date_col='_created_at') }}
  , case when alloc._created_at = b.max_created_at then 1 else 0 end                     as is_latest
  , dt.prior_market_date                                                                 as effective_date
  , alloc._created_at                                                                    as _created_at
  , alloc._source_file                                                                   as _source_file
  , alloc._uri                                                                           as _uri
from {{ source('copilot', 'allocations') }}                                            alloc
     left join (
                   select
                       _created_at::date   as _created_date
                     , max(_created_at)    as max_created_at
                   from {{ source('copilot', 'allocations') }}
                   group by 1
               )                                          b
     on alloc._created_at::date = b._created_date::date
         and alloc._created_at = b.max_created_at
    left join {{ ref('dates' )}} dt
      on alloc._created_at::date = dt.date_key
   , lateral flatten(input => alloc.json, path => 'memberList', outer => true, mode => 'array')     m
   , lateral flatten(input => alloc.json, path => 'order', outer => true, mode => 'array')          o
where 1=1
