select
     a.json:account_number::varchar(50)   as account_number
    ,a.json:open_date::date               as open_date
    ,a.json:description::varchar(200)     as description
    ,a.json:type::varchar(100)            as type
    ,a.json:rep::varchar(50)              as rep_id
    ,a.json:status::varchar(100)          as status
    ,a.json:market_value::decimal(17,2)   as market_value
    ,a.json:sweep::varchar(50)            as sweep
    ,a.json:buying_power::decimal(17,2)   as buying_power
    ,a.json:net_balance::decimal(17,2)    as net_balance
    ,dt.prior_market_date                 as effective_date
    ,{{ col_is_head(reference=source('tda', 'accounts_balances'), reference_date_col='_extracted_at', source_date_col='a._extracted_at') }}
    ,a._extracted_at::timestamp_ltz       as _extracted_at
    ,a._created_at::timestamp_ltz         as _created_at
    ,a._source_file                       as _source_file
    ,a._checksum                          as _checksum
from {{ source('tda', 'accounts_balances') }} a
join {{ ref('dates') }} dt
    on a._extracted_at::date = dt.date_key
