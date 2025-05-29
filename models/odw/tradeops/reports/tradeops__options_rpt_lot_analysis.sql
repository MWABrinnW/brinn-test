{{ config(
    tags = ['options', 'copilot', 'trading'],
    grants = {'select': ['trading_options']}
) }}

with accounts as (
    select
        lower(custodian) as custodian
        , account_no     as account_number
    from {{ ref('flyer__stg_sod_accounts_history') }}
    where 1 = 1
        and _created_at::date = (select max(t._created_at::date) from {{ ref('flyer__stg_sod_accounts_history') }} as t)
    group by all
)

, dates as (
    select coalesce(
        getvariable('EFFECTIVE_DATE')
        , (select max(effective_date) from {{ ref('bld_custodian_tax_lots') }})
    )::date as effective_date
)

, positions as (
    select
        h.effective_date                           as effective_date
        , h.custodian                              as custodian
        , h.account_number                         as account_number
        , coalesce(h.security_id_source , h.cusip) as security_id_source
        , h.symbol                                 as symbol
        , h.ticker                                 as ticker
        , h.cusip                                  as cusip
        , h.security_name                          as security_name
        , h.product_type_source_code               as product_type_source_code
        , h.product_type_source_definition         as product_type_source_definition
        , h.product_type                           as product_type
        , null::int                                as is_nigo
        , sum(h.quantity)                          as quantity
        , sum(h.market_value)                      as market_value
    from {{ ref('custodian_holdings') }} as h
    where 1 = 1
        and h.effective_date in (select t.effective_date from dates as t)
        and h.rn_global = 1
        and h.custodian in ('schwab' , 'fidelity')
        and h.account_number in (select t.account_number from accounts as t)
        -- Exclude sweep positions which don't have any lots
        and h.is_sweep = 0
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

, tax_lots as (
    select
        h.effective_date                                                          as effective_date
        , h.custodian                                                             as custodian
        , h.account_number                                                        as account_number
        , coalesce(h.security_id_source , h.cusip)                                as security_id_source
        , h.symbol                                                                as symbol
        , h.ticker                                                                as ticker
        , h.cusip                                                                 as cusip
        , null::text(200)                                                         as security_name
        , h.product_type_source_code                                              as product_type_source_code
        , h.product_type_source_definition                                        as product_type_source_definition
        , h.product_type                                                          as product_type
        , max(h._extra_fields:nigo_out_of_balance_exception_indicator::text)::int as is_nigo
        , sum(h.quantity)                                                         as quantity
        , sum(h.current_value)                                                    as market_value
    from {{ ref('custodian_tax_lots') }} as h
    where 1 = 1
        and h.custodian in ('schwab' , 'fidelity')
        and h.effective_date in (select t.effective_date from dates as t)
        and h.account_number in (select t.account_number from accounts as t)
        -- Some accounts might exist with more than one firm_source.
        -- We need to grab only one instance of the account.
        and h.rn_global = 1
    group by all
)

, lots_to_positions as (
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
            when position_quantity is null and tl.market_value = 0 then 'Missing position for zero value lot'
            when position_quantity is null then 'Missing position'
            when coalesce(tax_lot_quantity , 0) <> coalesce(position_quantity , 0) then 'Quantity mismatch'
        end                                                                              as explanation
        , tl.market_value::decimal(20 , 2)                                               as tax_lot_value
        , p.market_value::decimal(20 , 2)                                                as position_value
        , coalesce(
            tl.market_value - p.market_value , tl.market_value , p.market_value
        )::decimal(20 , 2)                                                               as value_diff
        , greatest(coalesce(p.is_nigo , 0) , coalesce(tl.is_nigo , 0))                   as is_nigo
        , coalesce(tl.product_type_source_code , p.product_type_source_code)             as product_type_source_code
        , coalesce(tl.product_type_source_definition , p.product_type_source_definition) as product_type_source_definition
        , coalesce(tl.product_type , p.product_type)                                     as product_type
    from tax_lots as tl
    left join positions as p
        on tl.effective_date = p.effective_date
        and tl.custodian = p.custodian
        and tl.account_number = p.account_number
        and tl.security_id_source = p.security_id_source
    where 1 = 1
        -- Exclude zero quantity positions.
        and tl.quantity <> 0
    order by explanation , abs(quantity_diff) desc
)

, positions_to_lots as (
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
        )::decimal(20 , 2)                                                               as quantity_diff
        , case
            when tax_lot_quantity is null and p.market_value = 0 then 'Missing cost basis for zero value position'
            when tax_lot_quantity is null then 'Missing cost basis'
            when coalesce(tax_lot_quantity , 0) <> coalesce(position_quantity , 0) then 'Quantity mismatch'
        end                                                                              as explanation
        , tl.market_value::decimal(20 , 2)                                               as tax_lot_value
        , p.market_value::decimal(20 , 2)                                                as position_value
        , coalesce(
            tl.market_value - p.market_value , tl.market_value , p.market_value
        )::decimal(20 , 2)                                                               as value_diff
        , greatest(coalesce(p.is_nigo , 0) , coalesce(tl.is_nigo , 0))                   as is_nigo
        , coalesce(tl.product_type_source_code , p.product_type_source_code)             as product_type_source_code
        , coalesce(tl.product_type_source_definition , p.product_type_source_definition) as product_type_source_definition
        , coalesce(tl.product_type , p.product_type)                                     as product_type
    from positions as p
    left join tax_lots as tl
        on p.effective_date = tl.effective_date
        and p.custodian = tl.custodian
        and p.account_number = tl.account_number
        and p.security_id_source = tl.security_id_source
    where 1 = 1
        -- Exclude zero quantity positions
        and p.quantity <> 0
    order by explanation , abs(quantity_diff) desc
)

, final as (
    select *
    from lots_to_positions

    union all

    select *
    from positions_to_lots
)

select
    f.effective_date                                            as effective_date
    , f.custodian                                               as custodian
    , f.account_number                                          as account_number
    , f.security_id_source                                      as security_id_source
    , f.symbol                                                  as symbol
    , f.ticker                                                  as ticker
    , f.cusip                                                   as cusip
    , f.position_description                                    as position_description
    , f.tax_lot_quantity                                        as tax_lot_quantity
    , f.position_quantity                                       as position_quantity
    , f.quantity_diff                                           as quantity_diff
    , f.explanation                                             as explanation
    , f.tax_lot_value                                           as tax_lot_value
    , f.position_value                                          as position_value
    , f.value_diff                                              as value_diff
    , f.is_nigo                                                 as is_nigo
    , f.product_type_source_code                                as product_type_source_code
    , f.product_type_source_definition                          as product_type_source_definition
    , f.product_type                                            as product_type
    , case
        when f.explanation is null
            then 1
        when f.explanation ilike '%zero%'
            then 1
        else 0
    end::int                                                    as is_match
    , case when e.ticker_or_cusip is not null then 1 else 0 end as is_excluded
from final as f
left join {{ ref('aux__base_options_exclusions') }} as e
    on f.symbol = e.ticker_or_cusip
    and e.is_head = 1
    and f.effective_date between
    coalesce(e.start_date , f.effective_date) and coalesce(e.end_date , f.effective_date)
group by all
order by custodian , symbol , account_number
