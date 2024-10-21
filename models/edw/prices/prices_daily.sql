select
    at_timestamp::date as date
    , symbol           as symbol
    , open_price       as open
    , close_price      as close
    , high_price       as high
    , low_price        as low
    , volume           as volume
    , trade_count      as trade_count
    , is_index         as is_index
    , 'activetick'     as system_key
    , _created_at
from {{ ref('activetick__stg_prices_daily') }}
where 1 = 1
    and is_latest = 1
