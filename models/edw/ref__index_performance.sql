{{ config(
  grants = {'select': ['db_edw_general_mwa_r']}
) }}

select
    prc.market_date       as market_date
    , dt.month_end_date   as month_end_date
    , prc.ticker          as ticker
    , prc.open            as open
    , prc.high            as high
    , prc.low             as low
    , prc.close           as close
    , prc.volume          as volume
    , prc.dividends       as dividends
    , prc.stock_splits    as stock_splits
    , prc.record_datetime as _created_at
from {{ source('reporting_int', 'historical_market_prices') }} as prc
inner join {{ ref('dates') }}                                  as dt
    on prc.market_date = dt.date_key
    and prc.market_date = dt.month_last_market_date
order by prc.market_date
