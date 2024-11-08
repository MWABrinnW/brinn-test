{{ config(
    grants = {'select': ['trading_options']}
) }}

with cte_internal as (
    -- Fourforty
    select
        execution_date as execution_date
        , custodian as custodian
        , account_number as account_number
        , symbol as symbol
        , max(price::decimal(20 , 2)) as price
        , sum(units_shares)           as internal_units
        , '440'                       as source
    from {{ ref('fourforty__int_orders_allocations') }}
    where 1 = 1
        -- We exclude today because the custodian data won't have record of them until
        -- the nexter day.
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
        -- the nexter day.
        and a.order_trade_date between dateadd('DAY' , -7 , current_date()) and current_date() - 1
        -- We only need to compare orders that resulted in an allocation.
        and abs(a.member_quantity) > 0
    group by all
)

, cte_external as (
    select
        transaction_date                as transaction_date
        , custodian                     as custodian
        , account_number                as account_number
        , symbol                        as symbol
        , max(price::decimal(20 , 2))   as price
        , sum(units_shares)             as external_units
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
    coalesce(inter.execution_date , exter.transaction_date) as trade_date
    , coalesce(inter.custodian , exter.custodian)           as custodian
    , coalesce(inter.account_number , exter.account_number) as account_number
    , coalesce(inter.symbol , exter.symbol)                 as symbol
    , listagg(inter.source)                                 as internal_sources
    , inter.internal_units::decimal(17 , 2)                 as units_internal
    , exter.external_units::decimal(17 , 2)                 as units_external
    , inter.price::decimal(15 , 3)                          as price_internal
    , exter.price::decimal(15 , 3)                          as price_external
    , abs(
        inter.internal_units - exter.external_units
    )::decimal(17 , 3)                                      as diff
    , case
        when units_internal is null then 'Unmatched external'
        when units_external is null then 'Unmatched Internal'
        when diff is not null and diff != 0
            and (div0(diff , abs(inter.internal_units)) < 0.01
            and inter.internal_units != 0) is not null
            and diff != 0
            and (DIV0(diff, abs(inter.internal_units)) < 0.01
            and inter.internal_units != 0)
            -- 1% buffer on unit match
            then 'Trade Matched'
        when diff is not null and diff != 0 then 'Internal/external Discrepancy'
        when diff = 0 then 'Trade Matched'
    end                                                     as match_type
    , iff(match_type = 'Trade Matched', 1, 0)               as is_matched
    , arrayagg(distinct ag.group_name)                      as groups
    , acc.account_title                                     as account_name
    , acc.restrictions_source_code                          as restrictions_source_code
from cte_internal as inter
full outer join cte_external as exter
    on inter.execution_date = exter.transaction_date
    and inter.custodian = exter.custodian
    and inter.account_number = exter.account_number
    and inter.symbol = exter.symbol
left join cte_accounts as acc
    on coalesce(
        inter.execution_date ,
        exter.transaction_date
        ) = acc.effective_date
    and coalesce(
        inter.custodian ,
        exter.custodian
        ) = acc.custodian
    and coalesce(
        inter.account_number ,
        exter.account_number
        ) = acc.account_number
left join {{ ref('tradeops__accounts_groups') }} ag
    on coalesce(
        acc.account_number ,
        inter.account_number ,
        exter.account_number
        ) = ag.account_number
group by all
