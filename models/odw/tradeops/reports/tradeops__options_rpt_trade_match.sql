{{ config(
    grants = {'select': ['trading_options']}
) }}

with internal as (
    -- Fourforty
    select
        execution_date
        , custodian
        , account_number
        , symbol
        , max(price::decimal(20 , 2)) as price
        , sum(units_shares)           as internal_units
        , '440'                       as source
    from {{ ref('fourforty__int_orders_allocations') }}
    where 1 = 1
        -- We exclude today because the custodian data won't have record of them until
        -- the next day.
        and execution_date between dateadd('DAY' , -7 , current_date()) and current_date() - 1
    group by all

    union all

    -- Copilot
    select
        a.order_trade_date                    as execution_date
        , lower(acc.custodian)                as custodian
        , a.member_account                    as account_number
        , coalesce(a.option_symbol_occ, a.symbol , a.order_symbol) as symbol
        , max(a.member_price)                 as price
        , sum(case
            when a.order_side = 1
                then abs(a.member_quantity)
            when a.order_side = 2
                then a.member_quantity * -1
            else a.member_quantity
        end)                                  as internal_units
        , a.platform                          as source
    from {{ ref('flyer__stg_orders_allocations') }} as a
    left join {{ ref('flyer__stg_accounts') }} as acc
        on a.member_account = acc.account_number
        and a.order_trade_date = acc._created_at::date
        and a._env = acc._env
        and acc.is_head_for_day = 1
    where 1 = 1
        and a._env = {{ "'" ~ copilot_env() ~ "'" }}
        and a.is_head = 1
        -- We exclude today because the custodian data won't have record of them until
        -- the next day.
        and a.order_trade_date between dateadd('DAY' , -7 , current_date()) and current_date() - 1
        -- We only need to compare orders that resulted in an allocation.
        and abs(a.member_quantity) > 0
    group by all
)

, external as (
    select
        transaction_date
        , custodian
        , account_number
        , symbol
        , max(price::decimal(20 , 2)) as price
        , sum(units_shares)           as external_units
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
    coalesce(int.execution_date , ext.transaction_date) as trade_date
    , coalesce(int.custodian , ext.custodian)           as custodian
    , coalesce(int.account_number , ext.account_number) as account_number
    , coalesce(int.symbol , ext.symbol)                 as symbol
    , listagg(int.source)                               as internal_sources
    , int.internal_units::decimal(17 , 2)               as units_internal
    , ext.external_units::decimal(17 , 2)               as units_external
    , int.price::decimal(15 , 3)                        as price_internal
    , ext.price::decimal(15 , 3)                        as price_external
    , abs(
        int.internal_units - ext.external_units
    )::decimal(17 , 3)                                  as diff
    , case
        when units_internal is null then 'Unmatched External'
        when units_external is null then 'Unmatched Internal'
        when diff is not null and diff != 0 and (div0(diff , abs(int.internal_units)) < 0.01 and int.internal_units != 0)
        is not null and diff != 0 and (DIV0(diff, abs(int.internal_units)) < 0.01 and int.internal_units != 0)
            -- 1% buffer on unit match
            then 'Trade Matched'
        when diff is not null and diff != 0 then 'Internal/External Discrepancy'
        when diff = 0 then 'Trade Matched'
    end                                                 as match_type
    , iff(match_type = 'Trade Matched', 1, 0)           as is_matched
    , arrayagg(distinct ag.group_name)                  as groups
    , acc.account_title                                 as account_name
    , acc.restrictions_source_code                      as restrictions_source_code
from internal as int
full outer join external as ext
    on int.execution_date = ext.transaction_date
    and int.custodian = ext.custodian
    and int.account_number = ext.account_number
    and int.symbol = ext.symbol
left join cte_accounts as acc
    on coalesce(int.execution_date , ext.transaction_date) = acc.effective_date
    and coalesce(int.custodian , ext.custodian) = acc.custodian
    and coalesce(int.account_number , ext.account_number) = acc.account_number
left join {{ ref('tradeops__accounts_groups') }} ag
    on coalesce(acc.account_number , int.account_number , ext.account_number) = ag.account_number
group by all
order by
    coalesce(int.custodian , ext.custodian)
    , coalesce(int.account_number , ext.account_number)
    , coalesce(int.symbol , ext.symbol)
    , coalesce(int.execution_date , ext.transaction_date) desc
