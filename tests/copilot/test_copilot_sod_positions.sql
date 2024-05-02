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
        'current'                               as src
        , effective_date                        as effective_date
        , count(*)                              as cnt
        , count(distinct account)               as cnt_accounts
        , sum(price * quantity)::number(20 , 2) as market_value
    from {{ ref('flyer__stg_sod_positions_history') }}
    where is_head_for_day = 1
        and effective_date >= current_date - 7
    group by all
)

, cte_history_averaged as (
    select
        src
        , avg(cnt)          as avg_count
        , avg(cnt_accounts) as avg_count_accounts
        , avg(
            market_value)::number(
            20
            , 2
        )                   as avg_market_value
    from cte_history
    group by all
)

select
    a.cnt                                                                             as current_cnt
    , b.avg_count::int                                                                as historical_cnt_avg
    , (a.cnt - b.avg_count)::int                                                      as diff_cnt
    , (abs(diff_cnt)::int / historical_cnt_avg::int)::number(8 , 3)                   as diff_cnt_percent

    , a.cnt_accounts                                                                  as current_cnt_accounts
    , b.avg_count_accounts::int                                                       as historical_cnt_accounts_avg
    , (a.cnt_accounts - b.avg_count_accounts)::int                                    as diff_cnt_accounts
    , (abs(diff_cnt_accounts)::int / historical_cnt_accounts_avg::int)::number(8 , 3) as diff_cnt_accounts_percent

    , a.market_value                                                                  as current_value
    , b.avg_market_value                                                              as historical_value_avg
    , a.market_value - b.avg_market_value                                             as diff_value
    , (abs(diff_value)::int / historical_value_avg::int)::number(12 , 3)              as diff_value_percent

    , a.cnt_null_product                                                              as cnt_null_product
from cte_current as a
cross join cte_history_averaged as b
where diff_cnt_accounts_percent > .03
    or diff_cnt_percent > .03
    or diff_value_percent > .03
    or a.cnt_null_product > 0
