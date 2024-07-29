{{ config(tags = ['custodian', 'copilot', 'options']) }}

with cte_current as (
    select
        'current'                               as src
        , count(*)                              as cnt
        , count(distinct account)               as cnt_accounts
        , sum(price * quantity)::number(20 , 2) as market_value
        , count_if(coalesce(product , '') = '') as cnt_null_product
    from {{ ref('flyer__sod_positions') }}
    group by all
)

, cte_history as (
    select
        'history'                               as src
        , effective_date
        , count(*)                              as cnt
        , count(distinct account)               as cnt_accounts
        , sum(price * quantity)::number(20 , 2) as market_value
    from {{ ref('flyer__stg_sod_positions_history') }}
    where is_head_for_day = 1
        and effective_date >= current_date - 15
    group by effective_date
)

, cte_history_averaged as (
    select
        src
        , avg(cnt)                             as avg_count
        , stddev(cnt)                          as stddev_count
        , avg(cnt_accounts)                    as avg_count_accounts
        , stddev(cnt_accounts)                 as stddev_count_accounts
        , avg(market_value)::number(20 , 2)    as avg_market_value
        , stddev(market_value)::number(20 , 2) as stddev_market_value
    from cte_history
    group by src
)

select
    a.cnt                                                           as current_cnt
    , b.avg_count::int                                              as historical_cnt_avg
    , (
        a.cnt - b.avg_count
    ) / b.stddev_count                                              as cnt_stddevs_away

    , a.cnt_accounts                                                as current_cnt_accounts
    , b.avg_count_accounts::int                                     as historical_cnt_accounts_avg
    , (
        a.cnt_accounts - b.avg_count_accounts
    ) / b.stddev_count_accounts                                     as cnt_accounts_stddevs_away

    , a.market_value                                                as current_value
    , b.avg_market_value                                            as historical_value_avg
    , (a.market_value - b.avg_market_value) / b.stddev_market_value
        as market_value_stddevs_away

    , a.cnt_null_product                                            as cnt_null_product
from cte_current as a
cross join cte_history_averaged as b
where abs(a.cnt - b.avg_count) > 3 * b.stddev_count
    or abs(a.cnt_accounts - b.avg_count_accounts) > 3 * b.stddev_count_accounts
    or abs(a.market_value - b.avg_market_value) > 3 * b.stddev_market_value
    or a.cnt_null_product > 0
order by a.cnt
