with cte_securities_partition as (
    select
        *
        , row_number() over (
            partition by symbol , sec_type
            order by price desc
        ) as rn
    from {{ ref('moxy__int_securities_build') }}
)

-- Mitigates having multiple securities of the same type with different prices
, cte_securities as (
    select *
    from cte_securities_partition
    where rn = 1
)

select
    t.account_number             as account_number
    , t.account_number_formatted as account_number_formatted
    , ma.portfolio_id            as portfolio_id
    , t.effective_date           as effective_date
    , t.symbol                   as symbol
    , t.ticker                   as ticker
    , t.cusip                    as cusip
    , t.quantity                 as quantity
    , s.price                    as price
    , t.factor                   as factor
    , t.current_price            as current_price
    , t.current_value            as current_value
    , t.is_custodial_cash        as is_custodial_cash
    , t.cost_per_share           as cost_per_share
    , t.cost_basis               as cost_basis
    , t.acquired_date            as acquired_date
    , t.product_type             as product_type
    , t.asset_class              as asset_class
    , t.product_category         as product_category
    , t.product_name             as product_name
    , t.product_id               as product_id
    , t.asset_id                 as asset_id
    , t.is_asset_managed::int    as is_managed
    , t.lot_id                   as lot_id

    , s.is_new                   as is_new_security
    -- New securities are guessed OR fallback to unknown (xmus/xuus).
    , s.sec_type                 as sec_type
    , s.iso_cfi                  as sec_iso
    , ma.is_intraday_import      as is_intraday_import

    , t._created_at              as _created_at
from {{ ref('mis__bld_tax_lots') }} as t
inner join {{ ref('moxy__int_accounts_build') }} as ma
    on upper(t.account_number) = upper(ma.account_number)
-- Join with moxy securities model to supplement fields
left join cte_securities as s
    on upper(t.symbol) = upper(s.symbol)
    and t.is_asset_managed = s.is_managed
where 1 = 1
    -- This is a loose guardrail. We want the head records but we also only
    -- want to return the head records if they represent the latest tax lots
    -- that we SHOULD have.
    and t.is_current = 1
    and t.is_moxy = 1
    and t.is_active = 1
    and t.quantity != 0
