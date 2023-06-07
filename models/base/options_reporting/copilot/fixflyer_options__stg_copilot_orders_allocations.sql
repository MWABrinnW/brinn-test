select
    a.value:allocId::string                                                               as allocation_allocid
  , a.value:userId::string                                                                as userid
  , a.value:tradingSessionId::string                                                      as allocation_tradingsessionid
  , a.value:clientOrderId::string                                                         as allocation_clientorderid
  , a.value:origClientOrderId::string                                                     as origclientorderid
  , a.value:allocTransType::string                                                        as alloctranstype
  , a.value:symbol::string                                                                as allocation_symbol
  , a.value:shares::number(19, 6)                                                         as shares
  , a.value:avgPx::number(19, 6)                                                          as allocation_avgpx
  , a.value:noOrders::int                                                                 as noorders
  , a.value:noExecs::int                                                                  as noexecs
  , a.value:side::string                                                                  as allocation_side
  , a.value:securityId::string                                                            as securityid
  , a.value:securityIdSrc::string                                                         as securityidsrc
  , try_to_date(a.value:tradeDate::varchar(100), 'YYYYMMDD')                              as allocation_tradedate
  , try_to_timestamp(a.value:transactTime::varchar(100), 'YYYYMMDD-HH24:MI:SS.FF3')       as allocation_transacttime
  , a.value:netMoney::string                                                              as netmoney
  , a.value:totNoAllocs::int                                                              as totnoallocs
  , a.value:noAllocs::int                                                                 as noallocs
  , a.value:currentAllocStatus::string                                                    as currentallocstatus
  , a.value:orderQty::number(19, 6)                                                       as allocation_orderqty
  , a.value:accruedInterestRate::number(19, 6)                                            as accruedinterestrate
  , a.value:custId::string                                                                as allocation_custid
  , a.value:userName::string                                                              as username
  , a.value:allocationMethod::string                                                      as allocationmethod
  , a.value:beginString::string                                                           as allocation_beginstring
  , a.value:onBehalfOfCompID::string                                                      as allocation_onbehalfofcompid
  , a.value:onBehalfOfSubID::string                                                       as onbehalifofsubid
  , a.value:targetCompId::string                                                          as allocation_targetcompid
  , a.value:senderCompId::string                                                          as allocation_sendercompid
  , m.value:allocId::string                                                               as member_allocid
  , m.value:indivAllocId::string                                                          as indivallocid
  , m.value:tradingSessionId::string                                                      as member_tradingsessionid
  , m.value:userId::string                                                                as member_userid
  , m.value:creatorId::string                                                             as member_creatorid
  , m.value:creatorName::string                                                           as member_creatorname
  , m.value:allocPrice::number(19, 6)                                                     as allocprice
  , m.value:allocQty::number(19, 6)                                                       as allocqty
  , m.value:allocAvgPx::number(19, 6)                                                     as allocavgpx
  , m.value:allocNetMoney::number(19, 6)                                                  as allocnetmoney
  , m.value:allocAmount::number(19, 6)                                                    as allocamount
  , m.value:allocAccount::string                                                          as allocaccount
  , m.value:originalOrderQty::number(19, 6)                                               as originalorderqty
  , m.value:originalClientOrderId::string                                                 as originalclientorderid
  , m.value:secFee::number(19, 6)                                                         as secfee
  , m.value:otherFee::number(19, 6)                                                       as otherfee
  , m.value:settlementType::string                                                        as settlementtype
  , m.value:accruedInterestAmount::number(19, 6)                                          as maccruedinterestamount
  , m.value:purchasePrice::number(19, 6)                                                  as purchaseprice
  , m.value:principal::number(19, 6)                                                      as principal
  , m.value:comm::number(19, 6)                                                           as comm
  , m.value:commType::string                                                              as commtype
  , m.value:allocAccountName::string                                                      as allocaccountname
  , m.value:lotId::string                                                                 as lotid
  , a.value:messageType::string                                                           as allocation_messagetype
  , a.value:messageSequenceNo::string                                                     as messagesequenceno
  , a.value:order.blockId::string                                                         as blockid
  , a.value:order.aggregatedClientOrderId::string                                         as aggregatedclientorderid
  , a.value:order.sleeveId::string                                                        as sleeveid
  , a.value:order.creatorId::string                                                       as order_creatorid
  , a.value:order.creatorName::string                                                     as order_creatorname
  , a.value:order.indivCount::number(19, 6)                                               as indivcount
  , a.value:order.autoSliceStatus::string                                                 as autoslicestatus
  , a.value:order.clientOrderId::string                                                   as order_clientorderid
  , a.value:order.userId::string                                                          as order_userid
  , a.value:order.tradingSessionId::string                                                as order_tradingsessionid
  , a.value:order.custId::string                                                          as order_custid
  , a.value:order.userName::string                                                        as order_username
  , a.value:order.traderId::string                                                        as traderid
  , a.value:order.traderName::string                                                      as tradername
  , a.value:order.custodialAccount::string                                                as custodialaccount
  , a.value:order.symbol::string                                                          as order_symbol
  , a.value:order.side::string                                                            as order_side
  , try_to_date(a.value:order.tradeDate::varchar(100), 'YYYYMMDD')                        as order_tradedate
  , a.value:order.timeInForce::string                                                     as timeinforce
  , a.value:order.execInst::string                                                        as execinst
  , a.value:order.orderType::string                                                       as ordertype
  , a.value:order.price::number(19, 6)                                                    as price
  , a.value:order.orderQty::number(19, 6)                                                 as order_orderqty
  , try_to_timestamp(a.value:order.transactTime::varchar(100), 'YYYYMMDD-HH24:MI:SS.FF3') as order_transacttime
  , a.value:order.account::string                                                         as account
  , a.value:order.stopPx::number(19, 6)                                                   as stoppx
  , a.value:order.handlInst::string                                                       as handlinst
  , a.value:order.expireTime::string                                                      as expiretime
  , a.value:order.commission::number(19, 6)                                               as commission
  , a.value:order.maxFloor::number(19, 6)                                                 as maxfloor
  , a.value:order.ratioQty::number(19, 6)                                                 as ratioqty
  , a.value:order.noLegs::string                                                          as nolegs
  , a.value:order.avgPx::number(19, 6)                                                    as order_avgpx
  , a.value:order.fillQty::number(19, 6)                                                  as fillqty
  , a.value:order.beginString::string                                                     as order_beginstring
  , a.value:order.targetCompId::string                                                    as order_targetcompid
  , a.value:order.senderCompId::string                                                    as order_sendercompid
  , a.value:order.messageType::string                                                     as order_messagetype
  , a.value:order.onBehalfOfCompID::string                                                as order_onbehalfofcompid
  , a.value:order.onBehalfOfSubID::string                                                 as onbehalfofsubid
  , a.value:order.validSymbol::boolean                                                    as validsymbol
  , a.value:order.assetClass::string                                                      as assetclass
  , a.value:order.restageFlag::boolean                                                    as restageflag
  , a.value:order.currentOrderStatus::string                                              as currentorderstatus
  , a.value:order.submittedBy::string                                                     as submittedby
  , a.value:order.option.clientOrdId::string                                              as option_clientordid
  , a.value:order.option.tradingSessionId::string                                         as option_tradingsessionid
  , a.value:order.option.userId::string                                                   as option_userid
  , try_to_date(a.value:order.option.maturityDate::varchar(100), 'YYYYMMDD')              as option_maturitydate
  , a.value:order.option.strikePrice::number(19, 6)                                       as option_strikeprice
  , a.value:order.option.putOrCall::string                                                as option_putorcall
  , a.value:order.option.positionEffect::string                                           as option_positioneffect
  , a.value:order.option.customerOrFirm::string                                           as option_customerorfirm
  , a.value:order.mutualFund.clientOrdId::string                                          as mutualfund_clientordid
  , a.value:order.mutualFund.tradingSessionId::string                                     as mutualfund_tradingsessionid
  , a.value:order.mutualFund.userId::string                                               as mutualfund_userid
  , a.value:order.mutualFund.state::string                                                as mutualfund_state
  , a.value:order.mutualFund.amount::number(19, 6)                                        as mutualfund_amount
  , a.value:order.mutualFund.round::string                                                as mutualfund_round
  , a.value:order.mutualFund.dividend::string                                             as mutualfund_dividend
  , a.value:order.mutualFund.longTermGain::string                                         as mutualfund_longtermgain
  , a.value:order.mutualFund.shortTermGain::string                                        as mutualfund_shorttermgain
  , a.value:order.mutualFund.initialOrFull::boolean                                       as mutualfund_initialorfull
  , a.value:order.mutualFund.feeIndicator::boolean                                        as mutualfund_feeindicator
  , a.value:order.mutualFund.linkQtyPercent::number(19, 6)                                as mutualfund_linkqtypercent
  , a.value:order.mutualFund.linkAmount::number(19, 6)                                    as mutualfund_linkamount
  , a.value:order.fixedIncome.clientOrderId::string                                       as fixedincome_clientorderid
  , a.value:order.fixedIncome.tradingSessionId::string                                    as fixedincome_tradingsessionid
  , a.value:order.fixedIncome.userId::string                                              as fixedincome_userid
  , a.value:order.fixedIncome.couponRate::number(19, 6)                                   as fixedincome_couponrate
  , a.value:order.fixedIncome.securityDesc::string                                        as fixedincome_securitydesc
  , a.value:order.fixedIncome.priceType::string                                           as fixedincome_pricetype
  , a.value:order.fixedIncome.accruedInterestAmt::number(19, 6)                           as fixedincome_accruedinterestamt
  , a.value:order.fixedIncome.factor::number(19, 6)                                       as fixedincome_factor
  , a.value:order.fixedIncome.product::number(19, 6)                                      as fixedincome_product
  , a.value:order.fixedIncome.yield::number(19, 6)                                        as fixedincome_yield
  , a.value:order.fixedIncome.originalFace::number(19, 6)                                 as fixedincome_originalface
  , a.value:order.fixedIncome.principal::number(19, 6)                                    as fixedincome_principal
  , {{ col_is_head(reference=source('copilot', 'copilot_orders_allocations'), source_date_col='oa.record_datetime', reference_date_col='record_datetime') }}
  , oa.record_date
  , oa.record_datetime
from {{ source('copilot', 'copilot_orders_allocations') }}                                            oa
   , lateral flatten(input => oa.variant_data, path => 'allocations', outer => true, mode => 'array') a
   , lateral flatten(input => a.value, path => 'memberList', outer => true, mode => 'array')          m