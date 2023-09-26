select
    concat(source_order_id || '_' || source_allocation_id)                                   as allocation_id
  , 'fourforty'                                                                              as platform
    -- default value: "MWA - Options"
  , venue                                                                                    as venue
    -- default value: "MWA"
  , lower(firm)                                                                              as firm
  , lower(custodian)                                                                         as custodian
  , custodian::text(200)                                                                     as broker_name
  , trader                                                                                   as trader
  , financial_account                                                                        as account_number
  , source_order_id                                                                          as source_order_id
  , ticker                                                                                   as ticker
  , symbol                                                                                   as symbol
  , cusip                                                                                    as cusip
  , source_security_type                                                                     as source_security_type
  , source_security_description                                                              as source_security_description
    -- should always result in 0 for options
  , case
        when order_side = 'BUY' and order_effect = 'LONG' then 'BUY'
        when order_side = 'BUY' and order_effect = 'COVER' then 'BUYCOVER'
        when order_side = 'SELL' and order_effect = 'LONG' then 'SELL'
        when order_side = 'SELL' and order_effect = 'SHORT' then 'SELLSHORT'
        else null
        end                                                                                  as order_type
  , case
        when lower(broker_name) != lower(custodian) then 1
        else 0
        end::int                                                                             as is_trade_away
  , units                                                                                    as units
  , unit_price                                                                               as unit_price
  , principal                                                                                as principal
  , interest                                                                                 as interest
  , net                                                                                      as net
  , commission                                                                               as commission
  , convert_timezone('America/Chicago', to_timestamp_tz(trade_start_utc || '+00:00'))        as trade_start_at
  , convert_timezone('America/Chicago', to_timestamp_tz(trade_end_utc || '+00:00'))          as trade_end_at
  , to_date(convert_timezone('America/Chicago', to_timestamp_tz(trade_end_utc || '+00:00'))) as execution_date
  , convert_timezone('America/Chicago', to_timestamp_tz(trade_end_utc || '+00:00'))          as execution_at
  , settle_date                                                                              as settle_date
  , record_datetime                                                                          as _created_at
from {{ ref('fourforty__stg_orders_allocations') }}
