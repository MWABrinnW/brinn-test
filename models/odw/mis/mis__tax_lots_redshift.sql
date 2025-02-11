select
    a.effective_date                   as effective_date
    , a.custodian                      as custodian
    , a.account_number                 as account_number
    , a.account_number_formatted       as account_number_formatted
    , acc.account_number               as crm_account_number
    , a.account_id                     as pms_account_id
    , acc.is_active                    as is_active
    , a.symbol                         as symbol
    , a.ticker                         as ticker
    , a.cusip                          as cusip
    , a.is_custodial_cash              as is_custodial_cash
    , coalesce(
        a.lot_quantity
        , a.aggregate_asset_quantity
        , 0
    )::decimal(20 , 5)                 as quantity
    -- Do we need all these fields? If so, TODO incorporate factorization
    -- appropriately.
    , (
        a.current_price / coalesce(nullif(a.factor::decimal(20 , 12) , 0) , 1)
    )::decimal(20 , 5)                 as current_price
    , (
        (a.current_price / coalesce(nullif(a.factor::decimal(20 , 12) , 0) , 1)
        )::decimal(20 , 9) * quantity
    )::decimal(20 , 2)                 as current_value
    , a.current_price::decimal(20 , 5) as current_price_raw
    , a.lot_value::decimal(20 , 2)     as current_value_raw
    , (
        a.current_price / coalesce(
            nullif(a.factor::decimal(20 , 12) , 0) , 1
        )
    )::decimal(20 , 5)                 as current_price_unfactored
    , (
        coalesce(
            a.lot_quantity , a.aggregate_asset_quantity , 0
        )::decimal(20 , 5)
        * (
            a.current_price::decimal(20 , 5) / coalesce(nullif(a.factor::decimal(20 , 12) , 0) , 1)
        )::decimal(20 , 9)
    )::decimal(20 , 2)                 as current_value_unfactored
    , a.factor::decimal(20 , 12)       as factor
    , a.cost_per_share                 as cost_per_share
    , a.cost_basis                     as cost_basis
    , a.acquired_date                  as acquired_date
    , a.product_name                   as product_name
    , a.product_type                   as product_type
    , a.asset_class                    as asset_class
    , a.product_category               as product_category
    , a.product_id                     as product_id
    , a.asset_id                       as asset_id
    , a.is_asset_managed               as is_asset_managed
    , a.lot_id                         as lot_id
    , acc.is_included                  as is_included
    , acc.is_perform                   as is_perform
    , acc.is_moxy                      as is_moxy
    , acc.is_intraday_import           as is_intraday_import
    , a._created_at                    as _created_at
from {{ ref('mis__stg_orion_tax_lots_redshift') }} as a
-- join with mis_accounts here to tag perform/moxy
left join {{ ref('mis__accounts') }} as acc
    on a.account_id = acc.pms_account_id
    and acc.rn = 1
where 1 = 1
    and a.is_head = 1
    -- Include MWA only
    and a.fkalclient = 568
    -- Exclude zero quantity positions except for custodial cash positions? This appears
    -- to mimic MIS 1.0
    and (
        coalesce(quantity , 0) <> 0
        or a.ticker ilike '%_cash%'
        or a.is_custodial_cash = 1
    )
