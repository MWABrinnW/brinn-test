select
    a.system_name                                   as system_name
    , a.system_instance                             as system_instance
    , a.system_key                                  as system_key
    , a.firm_source                                 as firm_source
    , a.account_number_formatted                    as account_number_formatted
    , a.account_number                              as account_number
    , a.account_number                              as internal_account_number
    , substring(a.account_number_formatted , 1 , 3) as internal_household_number
    , a.client_name                                 as registrant_name
    , a.client_name                                 as account_name
    , a.client_name                                 as client_name
    , a.client_type_desc                            as type_of_account
    -- sums position market value to generate account value
    , sum(a.market_value) over (
        partition by a.effective_date , a.account_number , a._created_at , a._source_file
    )                                               as account_value
    , a.effective_date                              as effective_date
    , last_day(a.effective_date)                    as month_end_date
    , 'L-10004'                                     as location_code
    , a.is_current                                  as is_current
    , a.is_head                                     as is_head
    , a.is_head_for_day                             as is_head_for_day
    , a._source_file                                as _source_file
    , a._created_at                                 as _created_at
from {{ ref("tpg_hfw__stg_holdings") }} as a
inner join {{ ref('dates') }} as dt
    on a.effective_date = dt.date_key
    and dt.is_market_day = 1
where true
    and a.effective_date >= '2024-11-01'
    -- application of the deduplication filter
    and a.rn = 1
    -- returns one row per account from holdings records
qualify row_number() over (
        partition by a.effective_date , a.account_number
        order by a._created_at desc , a._source_file asc
    ) = 1
