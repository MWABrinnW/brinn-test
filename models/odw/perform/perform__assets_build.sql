with cte_lots_base as (
    select
        trim(
            regexp_replace(lower(t.crm_account_number) , '(s-|r-|-)' , '')
        )                     as account_number
        , case
            when t.ticker = 'MUB' then 'MUBETF343'
            when t.ticker = 'SUB' then 'SUBETF343'
            else t.ticker
        end::text(200)        as ticker
        , case
            when t.ticker = 'MUB' then 'MUBETF343'
            when t.ticker = 'SUB' then 'SUBETF343'
            else t.cusip
        end::text(200)        as cusip
        , t.quantity          as quantity
        , t.factor            as factor
        , t.current_price     as current_price
        , t.current_value     as current_value
        , t.is_custodial_cash as is_custodial_cash
        , t.cost_per_share    as cost_per_share
        , t.cost_basis        as cost_basis
        , t.acquired_date     as acquired_date
        , t.product_type      as product_type
        , t.asset_class       as asset_class
        , t.product_category  as product_category
        , t.product_id        as product_id
        , t.asset_id          as asset_id
        , t.lot_id            as lot_id
        , 'orion'::text(200)  as source
    from {{ ref('mis__tax_lots') }} as t
    inner join {{ ref('mis__accounts') }} as a
        on t.pms_account_id = a.pms_account_id
        and a.closing_date is null
    where 1 = 1
        and t.is_perform = 1
)

, cte_perform_lots as (
    -- We'll use lot acquired date and cost from perform as the preferred values.
    select
        portfolio_id            as portfolio_id
        , account_number        as account_number
        , cusip                 as cusip
        , size::decimal(20 , 5) as quantity
        , acquired_date::date   as acquired_date
        , cost::decimal(20 , 5) as cost_per_share
        , row_number() over (
            partition by portfolio_id , cusip , size
            order by acquired_date
        )                       as rn
    from {{ ref('perform__stg_holdings') }}
    where is_head = 1
)

, cte_perform_accounts_build as (
    select
        account_key as account_number
        , blotter_target
    from {{ ref('perform__accounts_build') }}
)

, cte_perform_accounts as (
    -- Use the perform account extract to join back in the portfolio_id and port_status.
    select
        portfolio_id
        , port_status
        , account_number
        , row_number() over (
            partition by portfolio_id
            order by account_number
        ) as rn
    from {{ ref('perform__stg_accounts') }}
    where is_head = 1
)

, cte_cash as (
    select
        account_number
        , null::text(200)        as ticker
        , 'CASH'::text(200)      as cusip
        , sum(quantity)          as quantity
        , null::decimal(20 , 12) as factor
        , 1                      as current_price
        , sum(current_value)     as current_value
        , null::int              as is_custodial_cash
        , 1                      as cost_per_share
        , null::decimal(20 , 2)  as cost_basis
        , null::date             as acquired_date
        , null::text(200)        as product_type
        , null::text(200)        as asset_class
        , null::text(200)        as product_category
        , null::int              as product_id
        , null::int              as asset_id
        , null::int              as lot_id
        , source
    from cte_lots_base
    where 1 = 1
        and (
            is_custodial_cash = 1
            or product_category ilike 'cash'
            or asset_class ilike 'cash and cash equivalents'
            or ticker ilike '%cash'
        )
        -- These need t not be bundled in as cash and should be distinct
        -- line items.
        and ticker not in ('SNOXX' , 'FDRXX' , 'SNSXX')
    group by all
)

, cte_positions as (
    select
        account_number
        , ticker
        , cusip
        , quantity
        , factor
        , case
            when product_type ilike any ('bond' , 'cd')
                then current_price * 100
            else current_price
        end as current_price
        , current_value
        , is_custodial_cash
        , case
            when product_type ilike any ('bond' , 'cd')
                then cost_per_share * 100
            else cost_per_share
        end as cost_per_share
        , cost_basis
        , acquired_date
        , product_type
        , asset_class
        , product_category
        , product_id
        , asset_id
        , lot_id
        , source
    from cte_lots_base
    where 1 = 1
        and (
            (
                (
                    coalesce(is_custodial_cash , 0) <> 1
                    and coalesce(product_category , '') not ilike 'cash'
                    and coalesce(asset_class , '') not ilike 'cash and cash equivalents'
                    and coalesce(ticker , '') not ilike '%cash'
                )
                -- Excludes non-cash assets that have no corresponding lot(s)
                and lot_id is not null
            )
            -- These cash like positions do not get bundled in as CASH and should
            -- be distinct line items for the import.
            or ticker in ('SNOXX' , 'FDRXX' , 'SNSXX')
        )
)

, cte_unioned as (
    select * from cte_positions
    union all
    select * from cte_cash
)


select
    a.account_number                   as account_number
    , a.ticker                         as ticker
    , a.cusip                          as cusip
    , a.quantity::decimal(20 , 3)      as quantity
    , a.factor                         as factor
    , a.current_price::decimal(20 , 3) as current_price
    , a.current_value::decimal(20 , 2) as current_value
    , a.is_custodial_cash              as is_custodial_cash
    , case
        when a.cusip not in ('CASH')
            and (
                coalesce(a.cost_per_share , 0) = 0
                or coalesce(a.acquired_date , '1900-01-01') = '1900-01-01'
            )
            then coalesce(pl.cost_per_share , a.cost_per_share)
        else a.cost_per_share
    end::decimal(20 , 3)               as cost_per_share
    , a.cost_basis::decimal(20 , 3)    as cost_basis
    , to_varchar(case
        when a.cusip not in ('CASH')
            and (
                coalesce(a.cost_per_share , 0) = 0
                or coalesce(a.acquired_date , '1900-01-01') = '1900-01-01'
            )
            then coalesce(pl.acquired_date , a.acquired_date)::date
        when a.cusip ilike 'CASH'
            then a.acquired_date::date
        -- Unsure if perform requires a date. But the legacy workflow
        -- suggests this is the case because it does populate a dummy date
        -- for cash positions like FDRXX.
        else coalesce(a.acquired_date , '1900-01-01')::date
    end , 'MM/DD/YYYY')                as acquired_date
    , a.product_type                   as product_type
    , a.asset_class                    as asset_class
    , a.product_category               as product_category
    , a.product_id                     as product_id
    , a.asset_id                       as asset_id
    , a.lot_id                         as lot_id
    , a.source                         as source
    , pab.blotter_target               as blotter_target
    , pa.portfolio_id                  as portfolio_id
    , pa.port_status                   as port_status
    , row_number() over (
        order by a.account_number , a.ticker , a.quantity , a.lot_id , a.acquired_date
    )                                  as id
from cte_unioned as a
left join cte_perform_lots as pl
    on a.account_number = pl.account_number
    and a.cusip = pl.cusip
    and a.quantity::decimal(20 , 3) = pl.quantity::decimal(20 , 3)
    and pl.rn = 1
left join cte_perform_accounts_build as pab
    on a.account_number = pab.account_number
left join cte_perform_accounts as pa
    on a.account_number = pa.account_number
    and pa.rn = 1
where 1 = 1
    and coalesce(pa.port_status , '') <> 'Closed'
