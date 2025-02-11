with dates as (
    select coalesce(
        getvariable('EFFECTIVE_DATE')
        , (select max(effective_date) from {{ ref('mis__stg_orion_tax_lots_api') }})
    )::date as effective_date
)

, mis_accounts as (
    select
        account_number
        , account_number_formatted
        , pms_account_id
        , is_active
        , is_included
        , is_perform
        , is_moxy
        , is_intraday_import
    from {{ ref('mis__accounts') }}
    where 1 = 1
        and is_included = 1
        and rn = 1
)

{# , orion_prices as (
    select
        a.effective_date
        , a.asset_id
        , a.current_price
    from {{ ref('mis__tax_lots_redshift') }} a
    where 1 = 1
        and a.effective_date in (select tt.effective_date from dates as tt)
        and a.is_included = 1
    group by all
) #}

, orion_assets as (
    select
        t.effective_date             as effective_date
        , t.account_id               as account_id
        , t.account_number           as account_number
        , t.account_number_formatted as account_number_formatted
        , t.household_id             as household_id
        , t.household_name           as household_name
        , t.custodian                as custodian
        , t.symbol                   as symbol
        , t.cusip                    as cusip
        , t.ticker                   as ticker
        , t.is_ticker_cusip          as is_ticker_cusip
        , t.is_custodial_cash        as is_custodial_cash
        , t.product_name             as product_name
        , t.product_type             as product_type
        , t.product_category         as product_category
        , t.asset_class              as asset_class
        , t.factor                   as factor
        , t.is_asset_managed         as is_asset_managed
        , t.is_product_managed       as is_product_managed
        -- Prefer the redshift price (factored) when available.
        -- API prices can be a little off in comparison to data query/redshift
        -- for unknown reasons. The amount might ultimately be immaterial but
        -- with this we ought to avoid it 99% of the time.
        {# , coalesce(
            p.current_price
            , t.current_price
        )                            as price #}
        , t.current_price            as price
        , t.aggregate_asset_quantity as quantity
        , t.aggregate_asset_value    as value
        , t.product_id               as product_id
        , t.asset_id                 as asset_id
        , t.fkalclient               as fkalclient
        , t._created_at              as _created_at
        , t._extracted_at            as _extracted_at
    from {{ ref('mis__stg_orion_tax_lots_redshift') }} as t
    {# left join orion_prices as p
        on t.asset_id = p.asset_id #}
    where 1 = 1
        and t.effective_date in (select tt.effective_date from dates as tt)
        and t.is_head_for_day = 1
        -- The source table includes all of Orion data so we
        -- need to filter for just MIS accounts.
        and t.account_id in (select distinct tt.pms_account_id from mis_accounts as tt)
    group by all
)

, orion_lots as (
    select
        effective_date     as effective_date
        , account_id       as account_id
        , custodian        as custodian
        , id               as id
        , asset_id         as asset_id
        , short_term_units as short_term_units
        , short_term_cost  as short_term_cost
        , long_term_units  as long_term_units
        , long_term_cost   as long_term_cost
        , acquired_date    as acquired_date
        , product_id       as product_id
        , product_ticker   as product_ticker
        , product_name     as product_name
        , source           as source
        --, as_of_date          as as_of_date
        --, registration_name   as registration_name
        --, household_name      as household_name
        --, amortization_amt    as amortization_amt
        --, is_various          as is_various
        --, is_qualified        as is_qualified
        --, is_inherited        as is_inherited
        --, is_unknown          as is_unknown
        --, is_long_term        as is_long_term
        --, edited_date         as edited_date
        --, cost_basis_method   as cost_basis_method
        --, client_id           as client_id
        --, custodian_record_id as custodian_record_id
        --, _source_file        as _source_file
        , _created_at      as _created_at
        , _id              as _id
    from {{ ref('mis__stg_orion_tax_lots_api') }}
    where 1 = 1
        and is_head_for_day = 1
        -- This source table is already filtered to MIS account scope.
        and effective_date in (select tt.effective_date from dates as tt)
    -- If a product exists via both custodian and orion source then we need
    -- to prefer the custodian versions. If it only exists from orion we'll
    -- let it through.
    qualify dense_rank() over (
            partition by account_id , product_id
            order by case when lot_source = 'custodian' then 1 else 2 end
        ) = 1
)

-- Redshift format, which includes asset level and lot level in a way that
-- can produce the lot analysis.
select
    ass.effective_date                                         as effective_date
    , ass.account_id                                           as account_id
    , acc.account_number                                       as account_number
    , acc.account_number_formatted                             as account_number_formatted
    , acc.account_number                                       as crm_account_number
    , acc.is_active                                            as is_active
    , ass.household_id                                         as household_id
    , ass.household_name                                       as household_name
    , ass.custodian                                            as custodian
    , ass.symbol                                               as symbol
    , ass.cusip                                                as cusip
    , ass.ticker                                               as ticker
    , ass.is_ticker_cusip                                      as is_ticker_cusip
    , ass.is_custodial_cash                                    as is_custodial_cash
    , ass.product_name                                         as product_name
    , ass.product_type                                         as product_type
    , ass.product_category                                     as product_category
    , ass.asset_class                                          as asset_class

    , case
        when cb.id is not null
            then greatest(
                    coalesce(nullif(cb.long_term_units , 0) , nullif(cb.short_term_units , 0) , 0)
                )
    end::decimal(20 , 4)                                       as lot_quantity
    , ass.price                                                as current_price
    , case
        when cb.id is not null
            then greatest(
                    coalesce(nullif(cb.long_term_units , 0) , nullif(cb.short_term_units , 0) , 0)
                ) * ass.price
    end::decimal(20 , 2)                                       as lot_value
    , ass.factor::decimal(20 , 12)                             as factor
    -- Looks at asset (holding) only
    , ass.is_asset_managed::int                                as is_asset_managed
    -- Looks at product.
    , ass.is_product_managed::int                              as is_product_managed

    -------------------------------------------------------------------------------

    , cb.acquired_date::date                                   as acquired_date
    , greatest(
        coalesce(nullif(cb.long_term_cost , 0) , nullif(cb.short_term_cost , 0) , 0)
    )::decimal(20 , 2)                                         as cost_basis
    , case
        --when upper(ass.product_type) = 'CD'
        --    and lower(ass.custodian) = 'schwab'
        --    and cb.originalcostpershare > 0
        --    then cb.originalcostpershare / 100
        when lot_quantity > 0
            then (cost_basis / lot_quantity)
    end::decimal(20 , 5)                                       as cost_per_share

    -- Sum of tax lot units
    , sum(lot_quantity) over (
        partition by ass.effective_date , ass.account_id , ass.asset_id
    )::decimal(20 , 4)                                         as aggregate_lot_quantity
    -- Sum of asset/positions units
    , max(ass.quantity) over (
        partition by ass.effective_date , ass.account_id , ass.asset_id
    )::decimal(20 , 4)                                         as aggregate_asset_quantity
    -- Sum of lot market value
    , sum(lot_value) over (
        partition by ass.effective_date , ass.account_id , ass.asset_id
    )::decimal(20 , 2)                                         as aggregate_lot_value
    -- Sum of asset/positions calculated value
    , max(ass.value) over (
        partition by ass.effective_date , ass.account_id , ass.asset_id
    )::decimal(20 , 2)                                         as aggregate_asset_value
    , (aggregate_lot_quantity = aggregate_asset_quantity)::int as is_quantity_match
    , (aggregate_lot_value = aggregate_asset_value)::int       as is_value_match


    , ass.product_id                                           as product_id
    , ass.asset_id                                             as asset_id
    , cb.id                                                    as lot_id
    , '568'::int                                               as fkalclient

    , null::date                                               as last_recon_date
    , null::date                                               as expected_recon_date

    , acc.is_included                                          as is_included
    , acc.is_perform                                           as is_perform
    , acc.is_moxy                                              as is_moxy
    , acc.is_intraday_import                                   as is_intraday_import

    -- [META]
    , null::timestamp_ntz                                      as createddate
    , greatest_ignore_nulls(
        cb._created_at , ass._created_at
    )                                                          as _created_at
    , ass._extracted_at                                        as _extracted_at
from orion_assets as ass
left join orion_lots as cb
    on ass.asset_id = cb.asset_id
left join mis_accounts as acc
    on ass.account_id = acc.pms_account_id
where 1 = 1
