with mis_accounts as (
    select
        a.pms_account_id
        , a.trading_id
        , a.account_number
    from {{ ref('mis__accounts') }} as a
    where 1 = 1
        and a.is_perform = 1
        and a.is_active = 1
    group by all
    order by lower(a.account_number)
)

, perform_accounts as (
    select
        upper(account_number) as account_number
        , portfolio_type
    from {{ ref('perform__stg_accounts') }}
    where 1 = 1
        and is_head = 1
    group by all
)

, accounts_with_trades_today as (
    select account_number
    from odw.perform.fct_allocations
    where 1 = 1
        and trade_date = current_date
    group by all
)

, perform_positions as (
    select
        upper(portfolio_id)          as account_number
        , cusip                      as cusip
        , sum(size)::decimal(20 , 2) as quantity
    from {{ ref('perform__stg_holdings') }}
    where 1 = 1
        and is_head = 1
        and lower(portfolio_id) in (
            select lower(t.account_number)
            from mis_accounts as t
        )
    group by all
)

, source_positions as (
    select
        b.account_number     as account_number
        , a.account_id       as account_id
        , a.custodian        as custodian
        , case
            -- Orion doesn't have Midwest Trust custodian cash flagged but it does roll into CASH00008.
            when a.cusip = 'MM0000776' then 1
            -- FDRXX doesn't rollup in Perform.
            when a.cusip = '316067107' then 0
            -- Do bundle as cash
            when
                (
                    a.is_custodial_cash = 1
                    or a.product_category ilike 'cash'
                    or a.asset_class ilike 'cash and cash equivalents'
                    or a.ticker ilike '%cash'
                )
                and a.symbol not in ('SNOXX' , 'FDRXX' , 'SNSXX')
                then 1
            -- Don't bundle as cash
            when a.symbol in ('SNOXX' , 'FDRXX' , 'SNSXX') then 0
            else a.is_custodial_cash
        end::int             as is_custodial_cash
        , a.symbol           as symbol
        , a.cusip            as cusip
        , case
            -- If price is zero then perform holdings will show as zero quantity, I think.
            when a.current_price = 0 then 0
            else a.aggregate_asset_quantity
        end::decimal(20 , 2) as aggregate_asset_quantity
    from {{ ref('mis__stg_orion_tax_lots_redshift') }} as a
    inner join mis_accounts as b
        on a.account_id = b.pms_account_id
    where 1 = 1
        and a.is_head = 1
        and a.is_head_for_day = 1
        and abs(a.aggregate_asset_quantity) > 0
    group by all
)

, final as (
    select
        a.account_number                                                  as account_number
        , a.account_id                                                    as account_id
        , a.custodian                                                     as custodian
        , a.is_custodial_cash                                             as is_custodial_cash
        , a.symbol                                                        as symbol
        , a.cusip                                                         as cusip
        , sum(iff(a.is_custodial_cash = 1 , a.aggregate_asset_quantity , 0))
            over (partition by a.account_id)                              as total_source_custodial_cash
        , a.aggregate_asset_quantity                                      as source_quantity
        , c.quantity                                                      as dest_start_value
        , case
            when a.is_custodial_cash = 1 or c.cusip = 'CASH00008'
                then coalesce(total_source_custodial_cash , 0) - coalesce(dest_start_value , 0)
            else coalesce(source_quantity , 0) - coalesce(dest_start_value , 0)
        end                                                               as quantity_diff
        , case when abs(quantity_diff) > 0 then 0 else 1 end::int         as is_quantity_match
        , coalesce(total_source_custodial_cash , 0)::decimal(20 , 2)
        - coalesce(dest_start_value , 0)::decimal(20 , 2)                 as cash_diff
        , case when trd.account_number is not null then 1 else 0 end::int as has_trades_today
        , pa.portfolio_type                                               as blotter
    from source_positions as a
    inner join mis_accounts as b
        on a.account_id = b.pms_account_id
    left join perform_positions as c
        on a.account_number = c.account_number
        -- Custodial cash bundles into CASH00008 in Perform.
        and case when a.is_custodial_cash = 1 then 'CASH00008' else upper(a.cusip) end = upper(c.cusip)
    left join accounts_with_trades_today as trd
        on a.account_number = trd.account_number
    left join perform_accounts as pa
        on a.account_number = pa.account_number
    where 1 = 1
    order by lower(a.account_number) , a.symbol
)

select *
from final
where 1 = 1
    and is_quantity_match = 0
order by lower(account_number) , lower(symbol)
limit 10000
