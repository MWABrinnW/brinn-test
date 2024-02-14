select
    record_id::text(200)                                                as record_id
  , allocation_id::text(200)                                            as source_allocation_id
  , order_id::text(200)                                                 as source_order_id
  , to_date(trade_date, 'YYYY-MM-DD')                                   as trade_date
  , to_date(settle_date, 'MM/DD/YYYY HH12:MI:SS AM')                    as settle_date
  , asset_type::text(200)                                               as asset_type
  , symbol::text(200)                                                   as symbol
  , cusip::text(200)                                                    as cusip
  , ticker::text(200)                                                   as ticker
  , source_security_type::text(200)                                     as source_security_type
  , source_security_description::text(200)                              as source_security_description
  , order_side::text(200)                                               as order_side
  , order_effect::text(200)                                             as order_effect
  , units::number(19, 6)                                                as units
  , unit_price::number(19, 6)                                           as unit_price
  , principal::number(19, 6)                                            as principal
  , interest::number(19, 6)                                             as interest
  , commission::number(19, 6)                                           as commission
  , fees::number(19, 6)                                                 as fees
  , net::number(19, 6)                                                  as net
  , trim(financial_account)::text(200)                                  as financial_account
  , custodian::text(200)                                                as custodian
  , counter_party::text(200)                                            as counter_party
  , firm::text(200)                                                     as firm
  , venue::text(200)                                                    as venue
  , platform::text(200)                                                 as platform
  , trader::text(200)                                                   as trader
  , to_timestamp_ntz(trade_start_utc, 'MM/DD/YYYY HH12:MI:SS AM')       as trade_start_utc
  , to_timestamp_ntz(trade_end_utc, 'MM/DD/YYYY HH12:MI:SS AM')         as trade_end_utc
  , to_timestamp_ntz(source_trade_datetime, 'MM/DD/YYYY HH12:MI:SS AM') as source_trade_datetime
  , source_trade_tz::text(200)                                          as source_trade_tz
  , to_date(record_date, 'MM/DD/YYYY HH12:MI:SS AM')                    as record_date
  , to_timestamp_ntz(record_datetime, 'MM/DD/YYYY HH12:MI:SS AM')       as record_datetime
  , _created_at                                                         as _created_at
  , {{ col_is_head(
        reference=source('fourforty', 'orders_and_allocations'),
        source_date_col="to_date(trade_date, 'YYYY-MM-DD')",
         reference_date_col="to_date(trade_date, 'YYYY-MM-DD')") }}
from {{ source('fourforty', 'orders_and_allocations') }}

