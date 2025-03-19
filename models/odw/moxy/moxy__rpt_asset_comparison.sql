with mis_accounts as (
    -- Get the list of moxy accounts.
    select
        a.pms_account_id
        , a.trading_id
        , a.account_number
    from {{ ref('mis__accounts') }} as a
    where 1 = 1
        and a.is_moxy = 1
    group by all
    order by lower(a.trading_id)
)

, moxy_positions as (
    select
        port_id  as port_id
        , symbol as symbol
        , cusip  as cusip
        , sum(
            case
                when pos_type = 1
                    then open_pos * -1
                else open_pos
            end
        )        as open_pos
        , sum(
            case
                when pos_type = 1
                    then pre_alloc_pos * -1
                else pre_alloc_pos
            end
        )        as pre_alloc_pos
        , sum(
            case
                when pos_type = 1
                    then alloc_pos * -1
                else alloc_pos
            end
        )        as alloc_pos
    from {{ ref('moxy__stg_positions') }}
    where 1 = 1
        and is_head = 1
        and lower(port_id) in (
            select lower(t.trading_id)
            from mis_accounts as t
        )
    group by all
)

, moxy_accounts as (
    -- Get the moxy portfolio status.
    select
        portfolio_id
        , portfolio_status_id
    from {{ ref('moxy__stg_accounts') }}
    where 1 = 1
        and is_head = 1
    group by all
)

, moxy_cash as (
    -- We need to designate securities that moxy rolls into cash.
    select
        symbol
        , cusip
    from {{ ref('moxy__int_securities_build') }}
    where 1 = 1
        and sec_type = 'caus'
    group by all
)

, moxy_securities_raw as (
    select
        symbol  as symbol
        , cusip as cusip
    from moxy_positions
    group by all
)

, moxy_securities_spine as (
    select
        symbol  as symbol
        , cusip as cusip
        , row_number() over (
            partition by symbol
            order by cusip
        )       as rn_symbol
        , row_number() over (
            partition by cusip
            order by symbol
        )       as rn_cusip
    from moxy_securities_raw
)

, source_positions as (
    select
        a.account_number                             as account_number
        , a.account_id                               as account_id
        , a.custodian                                as custodian
        , case
            -- Use Moxy securities that are configured to rollup into MOXYCASH
            -- because it's not 1 to 1 with orion custodial cash settings.
            when mcash.symbol is not null then 1
            else 0
        end::int                                     as is_custodial_cash
        , coalesce(mc.symbol , ms.symbol , a.symbol) as symbol
        , coalesce(mc.cusip , ms.cusip , a.cusip)    as cusip
        , a.product_type                             as product_type
        , case
            when a.product_type ilike 'Option'
                then a.aggregate_asset_quantity / 100
            else
                a.aggregate_asset_quantity
        end::decimal(20 , 2)                         as aggregate_asset_quantity
    from {{ ref('mis__stg_orion_tax_lots_redshift') }} as a
    left join moxy_securities_spine as mc
        on upper(a.cusip) = upper(mc.cusip)
        and mc.rn_cusip = 1
    left join moxy_securities_spine as ms
        on a.symbol = ms.symbol
        and ms.rn_symbol = 1
    left join moxy_cash as mcash
        on a.symbol = mcash.symbol
    where 1 = 1
        and a.is_head = 1
        and a.is_head_for_day = 1
        and abs(a.aggregate_asset_quantity) > 0
        and a.account_id in (
            select t.pms_account_id
            from mis_accounts as t
        )
    group by all
)

, final as (
    select
        a.account_number                                          as account_number
        , a.account_id                                            as account_id
        , b.trading_id                                            as trading_id
        , ma.portfolio_status_id                                  as moxy_portfolio_status
        , a.custodian                                             as custodian
        , a.is_custodial_cash                                     as is_custodial_cash
        , a.product_type                                          as product_type
        , a.symbol                                                as symbol
        , a.cusip                                                 as cusip
        , sum(iff(a.is_custodial_cash = 1 , a.aggregate_asset_quantity , 0))
            over (partition by a.account_id)                      as total_custodial_cash
        , a.aggregate_asset_quantity                              as source_quantity
        , case
            when a.is_custodial_cash = 1 or c.symbol = 'MOXYCASH'
                then max(iff(c.symbol = 'MOXYCASH' , c.open_pos , null)) over (partition by c.port_id)
            else c.open_pos
        end                                                       as moxy_start_value
        , case
            when a.is_custodial_cash = 1
                then coalesce(total_custodial_cash , 0) - coalesce(moxy_start_value , 0)
            else coalesce(source_quantity , 0) - coalesce(moxy_start_value , 0)
        end                                                       as quantity_diff
        , case when abs(quantity_diff) > 0 then 0 else 1 end::int as is_quantity_match
        , c.pre_alloc_pos                                         as moxy_pre_alloc_pos
        , c.alloc_pos                                             as moxy_alloc_pos
        , coalesce(total_custodial_cash , 0)::decimal(20 , 2)
        - coalesce(moxy_start_value , 0)::decimal(20 , 2)         as cash_diff
    from source_positions as a
    inner join mis_accounts as b
        on a.account_id = b.pms_account_id
    left join moxy_accounts as ma
        on lower(b.trading_id) = lower(ma.portfolio_id)
    left join moxy_positions as c
        on lower(b.trading_id) = lower(c.port_id)
        -- Custodial cash bundles into MOXYCASH in Moxy.
        and case when a.is_custodial_cash = 1 then 'MOXYCASH' else upper(a.symbol) end = upper(c.symbol)
    where 1 = 1
    order by lower(b.trading_id) , a.symbol
)

select *
from final
where 1 = 1
    and is_quantity_match = 0
    and coalesce(product_type , '') not ilike 'Option'
    -- Include accounts that are flagged as open in Moxy.
    and moxy_portfolio_status = 1
order by lower(trading_id) , lower(symbol)
limit 10000
