select
    a.account_number             as account_number
    , a.portfolio_id             as portfolio_id
    , a.portfolio_name           as portfolio_name
    , a.portfolio_status_id      as portfolio_status_id
    , a.close_date               as close_date
    , a.user_def_10              as user_def_10

    , dt.prior_market_date       as effective_date
    , a.account_number_formatted as account_number_formatted
    , dense_rank() over (
        partition by dt.prior_market_date , a.account_number
        order by a._created_at desc
    )                            as rn
    , iff(rn = 1 , 1 , 0)        as is_head_for_day
    , {{ col_is_head(
      reference=ref('moxy__stg_accounts'),
      reference_date_col='_created_at',
      source_date_col='a._created_at'
      ) }}

    , a._created_at              as _created_at
    , a._source_file             as _source_file
    , a._id                      as _id
from {{ ref('moxy__stg_accounts') }} as a
inner join {{ ref('dates') }} as dt
    on a._created_at::date = dt.date_key
where 1 = 1
