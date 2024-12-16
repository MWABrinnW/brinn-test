select
    'moxy'::text                                                        as system_name
    , 'cincinnati'                                                      as system_instance
    , system_name || '__' || system_instance                            as system_key
    , to_timestamp_tz(
        a._data:tradedate::text , 'MM/DD/YYYY HH12:MI:SS AM'
    )                                          as traded_at
    , to_timestamp_ntz(
        a._data:settledate::text , 'MM/DD/YYYY HH12:MI:SS AM'
    )::date                                    as settle_date
    , a._data:orderid::int                     as order_id
    , a._data:allocationid::int                as allocation_id
    , a._data:portfolioid::int                 as portfolio_id
    , a._data:portfoliocode::text              as portfolio_code
    , a._data:custodianacctno::text            as custodian_acct_no
    , a._data:symbol::text                     as symbol
    , a._data:cusip::text                      as cusip
    , a._data:custodiansymbol::text            as custodian_symbol
    , a._data:transactioncode::text            as transaction_code
    , a._data:transactiontype::text            as transaction_type
    , a._data:allocqty::decimal(18 , 3)        as alloc_qty
    , a._data:allocprice::decimal(18 , 3)      as alloc_price
    , a._data:totalcost::decimal(18 , 2)       as total_cost
    , a._data:principalamt::text               as principal_amt
    , a._data:aiamt::text                      as ai_amt
    , a._data:netamt::text                     as net_amt
    , a._data:orderaiamount::decimal(18 , 2)   as order_ai_amount
    , a._data:grossamt::decimal(18 , 2)        as gross_amt
    , a._data:valuationfactor::decimal(18 , 4) as valuation_factor
    , a._data:ticketcharge::decimal(18 , 2)    as ticket_charge
    , a._data:ordertotalcost::decimal(18 , 2)  as order_total_cost
    , a._data:otherfee::decimal(18 , 2)        as other_fee
    , a._data:exchangefee::decimal(18 , 2)     as exchange_fee
    , a._data:executingbrokerfirmsymbol::text  as executing_broker_firm_symbol
    , a._data:clearingbrokerfirmsymbol::text   as clearing_broker_firm_symbol
    , a._data:securitytypecode::text           as security_type_code
    , a._data:assetclassname::text             as asset_class_name
    , a._data:fullname::text                   as full_name
    , a._data:createdby::text                  as created_by
    , a._data:approvedby::text                 as approved_by
    , a._data:placedby::text                   as placed_by

    , replace(
        upper(a._data:custodianacctno::text) , '-' , ''
    )                                          as account_number

    , dense_rank() over (
        partition by traded_at::date , allocation_id
        order by _created_at desc
    )                                          as rn
    , iff(rn = 1 , 1 , 0)                      as is_head

    , a._created_at                            as _created_at
    , a._source_file                           as _source_file
    , a._id                                    as _id
from {{ source('moxy', 'allocations') }} as a
