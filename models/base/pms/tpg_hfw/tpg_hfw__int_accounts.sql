select
    system_name                                   as system_name
    , system_instance                             as system_instance
    , system_key                                  as system_key
    , firm_source                                 as firm_source
    , account_number_formatted                    as account_number_formatted
    , account_number                              as account_number
    , account_number                              as internal_account_number
    , substring(account_number_formatted , 1 , 3) as internal_household_number
    , client_name                                 as registrant_name
    , client_name                                 as account_name
    , client_name                                 as client_name
    , client_type_desc                            as type_of_account
    -- sums position market value to generate account value
    , sum(market_value) over (
        partition by effective_date , account_number , _created_at , _source_file
    )                                             as account_value
    , effective_date                              as effective_date
    , last_day(effective_date)                    as month_end_date
    , 'L-10004'                                   as location_code
    , is_current                                  as is_current
    , is_head                                     as is_head
    , is_head_for_day                             as is_head_for_day
    , _source_file                                as _source_file
    , _created_at                                 as _created_at
from {{ ref("tpg_hfw__stg_holdings") }}
where true
    and effective_date >= '2024-11-01'
    -- application of the deduplication filter
    and rn = 1
    -- returns one row per account from holdings records
qualify row_number() over (
        partition by effective_date , account_number
        order by _created_at desc, _source_file
    ) = 1
