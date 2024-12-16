select
    system_name                                                                as system_name
    , system_instance                                                          as system_instance
    , system_key                                                               as system_key
    , perform_systicketno                                                      as order_id
    , trade_date                                                               as trade_date
    , settle_date                                                              as settle_date
    , portfolio_custodian                                                      as custodian
    , account_number                                                           as account_number
    , cusip                                                                    as cusip
    , case
        when side ilike 'buy'
            then 'buy'
        when side ilike 'sale'
            then 'sell'
    end::text                                                                  as order_side
    , 'long'::text(500)                                                        as order_effect
    , security_type                                                            as source_security_type
    , description                                                              as source_security_description
    , quantity                                                                 as units
    , price                                                                    as unit_price
    , principal                                                                as principal
    , interest                                                                 as interest
    , net_money                                                                as net
    , portfolio_account_number                                                 as portfolio_id
    , dealer                                                                   as broker_name
    , dealer_dtc                                                               as broker_id
    , account_type                                                             as owner
    , coalesce(broker_name != custodian , false)                               as trade_away
    , 'MWA'                                                                    as firm
    , 'MWA - Fixed Income'                                                     as venue
    , 'Perform'                                                                as platform
    , created_by                                                               as trader
    , (created_date_utc::string || ' ' || created_time_utc::string)::timestamp as traded_at
    --, (applied_date_utc::string || ' ' || applied_time_utc::string)::timestamp as trade_end_utc
    , _created_at                                                              as _created_at
    , _source_file                                                             as _source_file
from {{ ref('perform__stg_allocations') }}
where owner != 'Sample'
    and is_head = 1
