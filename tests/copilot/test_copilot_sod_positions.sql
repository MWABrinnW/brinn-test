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

, cte_history_records as (
    -- We need to select for max per day and then perform the aggregation
    -- in the next query.
    select
        effective_date
        , account
        , price
        , quantity
    from {{ ref('flyer__stg_sod_positions_history') }}
    where effective_date >= current_date - 30
    qualify _created_at = max(_created_at) over (partition by effective_date)
)

, cte_history as (
    -- Now we aggregate, after having grabbed the latest version of an SOD.
    -- This is in case more than one SOD upload was performed or if something
    -- unexpected occurs with the SOD history snapshot.
    select
        'history'                               as src
        , effective_date                        as effective_date
        , count(*)                              as cnt
        , count(distinct account)               as cnt_accounts
        , sum(price * quantity)::number(20 , 2) as market_value
    from cte_history_records
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
    -- count
    a.cnt                                                                                  as count_cur
    , b.avg_count::int                                                                     as count_hist_avg
    , b.stddev_count::decimal(20 , 2)                                                      as count_stddev
    , ((a.cnt - b.avg_count) / b.stddev_count)::decimal(20 , 2)                            as cnt_zscore

    -- count accounts
    , a.cnt_accounts                                                                       as cnt_accts
    , b.avg_count_accounts::int                                                            as cnt_accts_hist_avg
    , b.stddev_count_accounts::decimal(20 , 2)                                             as cnt_accts_stddev
    , ((a.cnt_accounts - b.avg_count_accounts) / b.stddev_count_accounts)::decimal(20 , 2) as cnt_accts_zscore

    -- market value
    , a.market_value::decimal(20 , 2)                                                      as market_value
    , b.avg_market_value::decimal(20 , 2)                                                  as market_value_hist_avg
    , b.stddev_market_value::decimal(20 , 2)                                               as market_value_stddev
    , ((a.market_value - b.avg_market_value) / b.stddev_market_value)::decimal(20 , 2)
        as market_value_zscore

    -- product count
    , a.cnt_null_product                                                                   as prouduct_cnt

from cte_current as a
cross join cte_history_averaged as b
where
    abs((a.cnt - b.avg_count) / b.stddev_count) > 5
    or abs((a.cnt_accounts - b.avg_count_accounts) / b.stddev_count_accounts) > 5
    or abs((a.market_value - b.avg_market_value) / b.stddev_market_value) > 5
    or a.cnt_null_product > 0
order by a.cnt
