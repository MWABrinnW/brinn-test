{{ config(
    tags = ['options', 'copilot', 'trading'],
    grants = {'select': ['trading_options']}
) }}

with cte_internal as (
    -- [Fourforty]
    select
        execution_date                as trade_date
        , custodian                   as custodian
        , account_number              as account_number
        , symbol                      as symbol
        , max(price::decimal(20 , 2)) as price
        , sum(units_shares)           as quantity
        --, '440'                       as source
    from {{ ref('fourforty__int_orders_allocations') }}
    where 1 = 1
        -- We exclude today because the custodian data won't have record of them until
        -- the nexter day.
        and execution_date between dateadd('DAY' , -7 , current_date()) and current_date() - 1
    group by all

    union all

    -- [Copilot]
    select
        a.trading_session_date                                      as trade_date
        , lower(acc.custodian)                                      as custodian
        , a.member_account                                          as account_number
        , coalesce(a.option_symbol_occ , a.symbol , a.order_symbol) as symbol
        , max(a.member_price)                                       as price
        , sum(case
            when a.order_side = 1
                then abs(a.member_quantity)
            when a.order_side = 2
                then a.member_quantity * -1
            else a.member_quantity
        end)                                                        as quantity
        --, a.system_key                                              as source
    from {{ ref('flyer__int_orders_allocations') }} as a
    left join {{ ref('flyer__stg_accounts') }} as acc
        on a.member_account = acc.account_number
        --and a.trading_session_date = acc._created_at::date
        and acc.is_head = 1
    where 1 = 1
        -- We exclude today because the custodian data won't have record of them until
        -- the nexter day.
        and a.trading_session_date between dateadd('DAY' , -7 , current_date()) and current_date() - 1
        -- We only need to compare orders that resulted in an allocation.
        and abs(a.member_quantity) > 0
    group by all
)

, cte_external as (
    select
        transaction_date              as trade_date
        , custodian                   as custodian
        , account_number              as account_number
        , symbol                      as symbol
        , max(price::decimal(20 , 2)) as price
        , sum(units_shares)           as quantity
    from {{ ref('flyer__custodian_trades') }}
    where 1 = 1
        -- exclude money market transactions
        and product_type_source_code not in ('MMN' , 'MMS' , 'SEMYM')
        and transaction_date >= dateadd('DAY' , -7 , current_date())
        and (is_in_sod = 1 or is_in_allocations = 1)
    group by all
)

, cte_accounts as (
    select
        effective_date
        , custodian
        , account_number
        , restrictions_source_code
        , account_title
    from {{ ref('nml_schwab_mwa_accounts') }}
    where effective_date >= current_date - 7

    union all

    select
        effective_date
        , custodian
        , account_number
        , restrictions_source_code
        , account_title
    from {{ ref('nml_fidelity_mwa_accounts') }}
    where effective_date >= current_date - 7
)

select
    coalesce(i.trade_date , e.trade_date)                 as trade_date
    , coalesce(i.custodian , e.custodian , acc.custodian) as custodian
    , coalesce(i.account_number , e.account_number)       as account_number
    , coalesce(i.symbol , e.symbol)                       as symbol
    , i.quantity::decimal(17 , 2)                         as units_internal
    , e.quantity::decimal(17 , 2)                         as units_external
    , i.price::decimal(15 , 3)                            as price_internal
    , e.price::decimal(15 , 3)                            as price_external
    , abs(
        i.quantity - e.quantity
    )::decimal(17 , 3)                                    as diff
    , case
        when units_internal is null then 'Unmatched external'
        when units_external is null then 'Unmatched internal'
        when diff is not null and diff <> 0
            and (
                div0(diff , abs(i.quantity)) < 0.01
                and i.quantity <> 0
            ) is not null
            and diff <> 0
            and (
                div0(diff , abs(i.quantity)) < 0.01
                and i.quantity <> 0
            )
            -- 1% buffer on unit match
            then 'Trade matched'
        when diff is not null and diff <> 0 then 'Internal/external Discrepancy'
        when diff = 0 then 'Trade matched'
    end                                                   as match_type
    , iff(match_type = 'Trade matched' , 1 , 0)           as is_match
    , arrayagg(distinct ag.group_name)                    as groups
    , acc.account_title                                   as account_name
    , acc.restrictions_source_code                        as restrictions_source_code
from cte_internal as i
full outer join cte_external as e
    on i.trade_date = e.trade_date
    and lower(i.custodian) = lower(e.custodian)
    and i.account_number = e.account_number
    and i.symbol = e.symbol
left join cte_accounts as acc
    on coalesce(
        i.trade_date
        , e.trade_date
    ) = acc.effective_date
    and coalesce(
        i.custodian
        , e.custodian
    ) = acc.custodian
    and coalesce(
        i.account_number
        , e.account_number
    ) = acc.account_number
left join {{ ref('tradeops__accounts_groups') }} as ag
    on coalesce(
        acc.account_number
        , i.account_number
        , e.account_number
    ) = ag.account_number
group by all
