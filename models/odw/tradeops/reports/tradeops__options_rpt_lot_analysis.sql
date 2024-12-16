{{ config(
    tags = ['options', 'copilot', 'trading'],
    grants = {'select': ['trading_options']}
) }}

with cte_accounts as (
    select distinct
        max(effective_date) over (partition by _created_at::date) as effective_date
        , lower(custodian)                                        as custodian
        , account_no                                              as account_number
    from {{ ref('flyer__stg_sod_accounts_history') }}
    where 1 = 1
        and _created_at::date = (select max(t._created_at::date) from {{ ref('flyer__stg_sod_accounts_history') }} as t)
    qualify row_number() over (partition by _created_at::date , account_no , custodian order by _created_at desc) = 1
)

, cte_effective_date as (
    select max(effective_date) as effective_date from cte_accounts
)

, cte_positions as (
    select
        h.effective_date
        , h.custodian
        , h.account_number
        , coalesce(h.security_id_source , h.cusip) as security_id_source
        , h.symbol
        , h.ticker
        , h.cusip
        , h.security_name                          as security_name
        , h.product_type_source_code
        , h.product_type_source_definition
        , h.product_type
        , 'positions'                              as src
        , null::text                               as is_nigo
        , sum(h.quantity)                          as quantity
        , sum(h.market_value)                      as market_value
    from {{ ref('custodian_holdings') }} as h
    where 1 = 1
        and h.rn_global = 1
        and h.custodian in ('schwab' , 'fidelity')
        -- Exclude sweep positions which don't have any lots
        and h.is_sweep = 0
        and h.effective_date = (select t.effective_date from cte_effective_date as t)
        and h.account_number in (select t.account_number from cte_accounts as t)
        -- Exclude fidelity positions that won't typically (or ever?) include
        -- corresponding lots.

        -- SUL = Units - Limited Partnership

        -- CASH = FX cash balance from Shadow (Intl only)

        -- SEMYM = Equity - Mutual Fund - Fidelity - Money Market
        -- Fidelity tax lots don't seem to include any of the Fidelity money
        -- market funds.
        and not (h.custodian = 'fidelity' and coalesce(h.product_type_source_code , '') in ('CASH' , 'SEMYM' , 'SUL'))

        -- Exclude schwab positions that won't typically (or ever?) include
        -- corresponding lots.

        -- RES = REORGANIZED STOCK
        and not (h.custodian = 'schwab' and coalesce(h.product_type_source_code , '') in ('RES'))
    group by all
)

, cte_tax_lots as (
    select
        h.effective_date
        , h.custodian
        , h.account_number
        , coalesce(h.security_id_source , h.cusip)                           as security_id_source
        , h.symbol
        , h.ticker
        , h.cusip
        , null::text(200)                                                    as security_name
        , h.product_type_source_code
        , h.product_type_source_definition
        , h.product_type
        , 'tax_lots'                                                         as src
        , max(h._extra_fields:nigo_out_of_balance_exception_indicator::text) as is_nigo
        , sum(h.quantity)                                                    as quantity
        , sum(h.current_value)                                               as market_value
    from {{ ref('custodian_tax_lots') }} as h
    where 1 = 1
        and h.custodian in ('schwab' , 'fidelity')
        and h.effective_date = (select t.effective_date from cte_effective_date as t)
        and h.account_number in (select t.account_number from cte_accounts as t)
        -- Some accounts might exist with more than one firm_source.
        -- We need to grab only one instance of the account.
        and h.rn_global = 1
    group by all
)

, cte_lots_to_positions as (
    select
        coalesce(tl.effective_date , p.effective_date)                                   as effective_date
        , coalesce(tl.custodian , p.custodian)                                           as custodian
        , coalesce(tl.account_number , p.account_number)                                 as account_number
        , coalesce(tl.security_id_source , p.security_id_source)                         as security_id_source
        , coalesce(tl.symbol , p.symbol)                                                 as symbol
        , coalesce(tl.ticker , p.ticker)                                                 as ticker
        , coalesce(tl.cusip , p.cusip)                                                   as cusip
        , p.security_name                                                                as position_description
        , tl.quantity::decimal(20 , 2)                                                   as tax_lot_quantity
        , p.quantity::decimal(20 , 2)                                                    as position_quantity
        , coalesce(
            tax_lot_quantity - position_quantity , tax_lot_quantity
            , position_quantity
        )                                                                                as quantity_diff
        , case
            when position_quantity is null then 'Tax Lot without Positions'
            when coalesce(tax_lot_quantity , 0) <> coalesce(position_quantity , 0) then 'Position vs Tax Lot quantity mismatch'
        end                                                                              as explanation
        , to_varchar(tl.market_value , '999,999,999,999')                                as tax_lot_value
        , to_varchar(p.market_value , '999,999,999,999')                                 as position_value
        , to_varchar(
            coalesce(tl.market_value - p.market_value , tl.market_value , p.market_value)
            , '999,999,999,999'
        )                                                                                as value_diff
        , 'tax_lots_to_positions'                                                        as src
        , greatest(coalesce(p.is_nigo , 0) , coalesce(tl.is_nigo , 0))                   as is_nigo
        , coalesce(tl.product_type_source_code , p.product_type_source_code)             as product_type_source_code
        , coalesce(tl.product_type_source_definition , p.product_type_source_definition) as product_type_source_definition
        , coalesce(tl.product_type , p.product_type)                                     as product_type
    from cte_tax_lots as tl
    left join cte_positions as p
        on tl.effective_date = p.effective_date
        and tl.custodian = p.custodian
        and tl.account_number = p.account_number
        and tl.security_id_source = p.security_id_source
    where 1 = 1
        -- Exclude zero quantity lots
        and tl.quantity <> 0
    order by explanation , abs(quantity_diff) desc
)

, cte_positions_to_lots as (
    select
        coalesce(p.effective_date , tl.effective_date)                                   as effective_date
        , coalesce(p.custodian , tl.custodian)                                           as custodian
        , coalesce(p.account_number , tl.account_number)                                 as account_number
        , coalesce(p.security_id_source , tl.security_id_source)                         as security_id_source
        , coalesce(p.symbol , tl.symbol)                                                 as symbol
        , coalesce(p.ticker , tl.ticker)                                                 as ticker
        , coalesce(p.cusip , tl.cusip)                                                   as cusip
        , p.security_name                                                                as position_description
        , tl.quantity::decimal(20 , 2)                                                   as tax_lot_quantity
        , p.quantity::decimal(20 , 2)                                                    as position_quantity
        , coalesce(
            tax_lot_quantity - position_quantity , tax_lot_quantity
            , position_quantity
        )                                                                                as quantity_diff
        , case
            when tax_lot_quantity is null then 'Position without Tax Lots'
            when coalesce(tax_lot_quantity , 0) <> coalesce(position_quantity , 0) then 'Position vs Tax Lot quantity mismatch'
        end                                                                              as explanation
        , to_varchar(tl.market_value , '999,999,999,999')                                as tax_lot_value
        , to_varchar(p.market_value , '999,999,999,999')                                 as position_value
        , to_varchar(
            coalesce(tl.market_value - p.market_value , tl.market_value , p.market_value)
            , '999,999,999,999'
        )                                                                                as value_diff
        , 'positions_to_tax_lots'                                                        as src
        , greatest(coalesce(p.is_nigo , 0) , coalesce(tl.is_nigo , 0))                   as is_nigo
        , coalesce(tl.product_type_source_code , p.product_type_source_code)             as product_type_source_code
        , coalesce(tl.product_type_source_definition , p.product_type_source_definition) as product_type_source_definition
        , coalesce(tl.product_type , p.product_type)                                     as product_type
    from cte_positions as p
    left join cte_tax_lots as tl
        on p.effective_date = tl.effective_date
        and p.custodian = tl.custodian
        and p.account_number = tl.account_number
        and p.security_id_source = tl.security_id_source
    where 1 = 1
        -- Exclude zero quantity positions
        and p.quantity <> 0
    order by explanation , abs(quantity_diff) desc
)

, cte_all as (
    select *
    from cte_lots_to_positions

    union all

    select *
    from cte_positions_to_lots
)

select *
from cte_all
qualify row_number() over (
    partition by effective_date , account_number , security_id_source
    order by case when src = 'tax_lots_to_positions' then 1 else 2 end
) = 1
