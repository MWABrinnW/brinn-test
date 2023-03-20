select
     json:account_number::varchar(50)   as account_number
    ,json:open_date::date               as open_date
    ,json:description::varchar(200)     as description
    ,json:type::varchar(100)            as type
    ,json:rep::varchar(50)              as rep_id
    ,json:status::varchar(100)          as status
    ,json:market_value::decimal(17,2)   as market_value
    ,json:sweep::varchar(50)            as sweep
    ,json:buying_power::decimal(17,2)   as buying_power
    ,json:net_balance::decimal(17,2)    as net_balance
    ,_extracted_at::timestamp_ltz       as effective_at
    ,_created_at::timestamp_ltz         as _created_at
    ,_source_file                       as _source_file
    ,_checksum                          as _checksum
from {{ source('tda', 'accounts_balances') }}