with cte_alloc as (
    select
        xmlget(xml , 'Perform_SysTicketNo'):"$"::string as id
        , xml
        , case
            when alloc.key is null then value
            when alloc.key = '$' then this
            else this
        end                                             as allocation_xml
        , _created_at                                   as _created_at
        , _source_file                                  as _source_file
    from {{ source('perform', 'allocations') }}
    , lateral flatten(xmlget(xml , 'allocations'):"$") as alloc
    where alloc.key is null
        or alloc.key = '$'
)

, cte_max_per_day as (
    select
        xmlget(xml , 'tradeDate'):"$"::date as trade_date
        , max(_created_at)                  as max_created_at
    from {{ source('perform', 'allocations') }}
    group by all
)

select
    'perform'::text                                                        as system_name
    , 'fi'                                                      as system_instance
    , system_name || '__' || system_instance                            as system_key
    , xmlget(a.xml , 'transType'):"$"::string                           as side
    , xmlget(a.xml , 'CUSIP'):"$"::string                               as cusip
    , replace(xmlget(a.xml , 'tprice'):"$" , ',')::double               as price
    , xmlget(a.xml , 'tradeDate'):"$"::date                             as trade_date
    , xmlget(a.xml , 'settleDate'):"$"::date                            as settle_date
    , xmlget(a.xml , 'dealer'):"$"::string                              as dealer
    , xmlget(a.xml , 'dealer_DTC'):"$"::string                          as dealer_dtc
    , xmlget(a.xml , 'Perform_SysTicketNo'):"$"::string                 as perform_systicketno
    , xmlget(a.xml , 'TicketNo'):"$"::string                            as ticketno
    , xmlget(a.xml , 'Desc'):"$"::string                                as description
    , case
        when xmlget(a.xml , 'matureDate'):"$" = '' then null
        else xmlget(a.xml , 'matureDate'):"$"::date
    end                                                                 as mature_date
    , case
        when xmlget(a.xml , 'coupon'):"$" = '' then null
        else replace(xmlget(a.xml , 'coupon'):"$" , ',')::double
    end                                                                 as coupon
    , xmlget(a.xml , 'sectype'):"$"::string                             as security_type
    , xmlget(a.xml , 'TCreatedDt'):"$"::date                            as created_date
    , xmlget(a.xml , 'TCreatedTime'):"$"::time                          as created_time
    , xmlget(a.xml , 'TCreatedDt_UTC'):"$"::date                        as created_date_utc
    , xmlget(a.xml , 'TCreatedTime_UTC'):"$"::time                      as created_time_utc
    , xmlget(a.xml , 'TCreatedBy'):"$"::string                          as created_by
    , xmlget(a.xml , 'TAppliedOrigDt'):"$"::date                        as applied_date
    , xmlget(a.xml , 'TAppliedOrigTime'):"$"::time                      as applied_time
    , xmlget(a.xml , 'TAppliedOrigDt_UTC'):"$"::date                    as applied_date_utc
    , xmlget(a.xml , 'TAppliedOrigTime_UTC'):"$"::time                  as applied_time_utc
    , xmlget(a.xml , 'TAppliedOrigBy'):"$"::string                      as applied_by
    , xmlget(a.xml , 'TAppliedLastDt'):"$"::date                        as applied_last_date
    , xmlget(a.xml , 'TAppliedLastTime'):"$"::time                      as applied_last_time
    , xmlget(a.xml , 'TAppliedLastDt_UTC'):"$"::date                    as applied_last_date_utc
    , xmlget(a.xml , 'TAppliedLastTime_UTC'):"$"::time                  as applied_last_time_utc
    , xmlget(a.xml , 'TAppliedLastBy'):"$"::string                      as applied_last_by
    , replace(xmlget(a.xml , 'quantity'):"$" , ',')::double             as trade_quantity
    , replace(xmlget(a.xml , 'principal'):"$" , ',')::double            as trade_principal
    , replace(xmlget(a.xml , 'interest'):"$" , ',')::double             as trade_interest
    , replace(xmlget(a.xml , 'net_money'):"$" , ',')::double            as trade_net_money
    , xmlget(a.allocation_xml , 'portfolio'):"$"::string                as portfolio
    , xmlget(a.allocation_xml , 'PortAcctNo'):"$"::string               as portfolio_account_number
    , xmlget(a.allocation_xml , 'portfolio_custodian'):"$"::string      as portfolio_custodian
    , replace(upper(portfolio_account_number) , '-' , '')               as account_number
    , xmlget(a.allocation_xml , 'account_type'):"$"::string             as account_type
    , replace(xmlget(a.allocation_xml , 'quantity'):"$" , ',')::double  as quantity
    , replace(xmlget(a.allocation_xml , 'principal'):"$" , ',')::double as principal
    , replace(xmlget(a.allocation_xml , 'interest'):"$" , ',')::double  as interest
    , replace(xmlget(a.allocation_xml , 'net_money'):"$" , ',')::double as net_money
    , xmlget(a.allocation_xml , 'inquiry_ID'):"$"::string               as inquiry_id
    , xmlget(a.allocation_xml , 'external_order_ID'):"$"::string        as external_order_id
    -- We can have multiple versions of the same allocation because we pull a rolling window
    , case
        when a._created_at = mxpd.max_created_at
            then 1
        else 0
    end::int                                                            as is_head
    , a._created_at                                                     as _created_at
    , a._source_file                                                    as _source_file
from cte_alloc as a
left join cte_max_per_day as mxpd
    on a._created_at = mxpd.max_created_at
    and xmlget(a.xml , 'tradeDate'):"$"::date = mxpd.trade_date
where 1 = 1
    and account_type ilike 'aipmanaged'
    and cusip not ilike 'subetf%'
    and cusip not ilike 'mubetf%'
