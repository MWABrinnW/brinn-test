{{ config(
    tags = ["report"]
    ) }}

select
    tl.effective_date                                      as effective_date
    , tl.custodian                                         as custodian
    , tl.account_number                                    as account_number
    , tl.symbol                                            as symbol
    , tl.ticker                                            as ticker
    , tl.cusip                                             as cusip
    , tl.aggregate_lot_quantity                            as tax_lot_quantity
    , tl.aggregate_asset_quantity                          as position_quantity
    , coalesce(
        tl.aggregate_lot_quantity::decimal(20 , 2) - position_quantity::decimal(20 , 2)
        , tax_lot_quantity
        , position_quantity
    )                                                      as quantity_diff
    , case
        when tax_lot_quantity is null and position_quantity is not null then 'Position without Tax Lots'
        when abs(quantity_diff) >= .05 then 'Position vs Tax Lot quantity mismatch'
    end                                                    as explanation
    , tl.aggregate_lot_value                               as tax_lot_value
    , tl.aggregate_asset_value                             as position_value
    , coalesce(
        tl.aggregate_lot_value - tl.aggregate_asset_value
        , tl.aggregate_lot_value
        , tl.aggregate_asset_value
    )                                                      as value_diff
    , tl.product_name                                      as product_name
    , tl.asset_class                                       as asset_class
    , tl.product_type                                      as product_type
    , tl.product_category                                  as product_category
    , tl.product_id                                        as product_id
    , tl.asset_id                                          as asset_id
    , a.trading_systems                                    as trading_systems
    , case when explanation is null then 1 else 0 end::int as is_match
    , tl._created_at                                       as _created_at
from {{ ref('mis__int_orion_tax_lots_api') }} as tl
inner join {{ ref('mis__accounts') }} as a
    on tl.account_number = a.account_number
    and a.is_perform = 1
where 1 = 1
    and tl.fkalclient = 568

    -- The old version of the report didn't exclude non managed assets. Going forward
    -- we are excluding them.
    and coalesce(tl.is_asset_managed , 0) = 1
    and a.closing_date is null
    -- Custodial cash doesn't include lots.
    and tl.is_custodial_cash = 0
    -- There are cash like positions which don't ever have lots (i.e. SNOXX, SWVXX, FMOXX, FMPXX).
    -- To handle (this may be too inclusive?) we'll exclude using the asset class.
    and coalesce(tl.asset_class , '') <> 'Cash and Cash Equivalents'
group by all
order by effective_date , account_number , symbol
