with mis_accounts as (
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
)

, dates as (
    select coalesce(
        getvariable('EFFECTIVE_DATE')
        , (select max(effective_date) from {{ ref('bld_custodian_tax_lots') }})
    )::date as effective_date
)

, fidelity_sweep as (
    select
        b.effective_date
        , b.custodian
        , b.account_custodial                          as account_number
        , a.pms_account_id
        , a.account_number                             as crm_account_number
        , a.is_active
        , a.is_perform
        , a.is_moxy
        , a.is_intraday_import
        , 'FID:CASH'::text                             as symbol
        , 'FID:CASH'::text                             as ticker
        , 'FID:CASH'::text                             as cusip
        -- Should we use core sweep fund?
        , -(b.net_trade_date_balance)::decimal(15 , 2) as quantity
        , b._source_loaded_at                          as _created_at
    from {{ ref('fidelity_mwa_history__vw_acctbald_account_balance') }} as b
    inner join mis_accounts as a
        on b.account_custodial = a.account_number
        and a.is_included = 1
    where 1 = 1
        and b.effective_date in (select t.effective_date from dates as t)
-- We'll allow through zero balance to mimic what we see from Orion.
--   and abs(b.net_trade_date_balance) > 0
)

, fidelity_core_funds as (
    select
        effective_date
        , account_number
        , ticker
    from {{ ref('int_fidelity_mwa_account_sweep_fund') }}
    where effective_date in (select t.effective_date from dates as t)
    group by all
)

, fidelity_mmf as (
    select
        p.effective_date                         as effective_date
        , p.custodian                            as custodian
        , p.account_custodial                    as account_number
        , a.account_number                       as crm_account_number
        , coalesce(p.symbol , p.cusip)           as symbol
        , p.symbol                               as ticker
        , p.cusip                                as cusip
        , case
            when p.product_code = 'SEMYM' or sweep.ticker is not null
                then 1
            else 0
        end::int                                 as is_cash
        , case
            when sweep.ticker is not null
                then 1
            else 0
        end::int                                 as is_sweep
        , p.trade_date_quantity::decimal(20 , 7) as quantity
        , p._source_loaded_at                    as _created_at
        , a.is_active                            as is_active
        , a.pms_account_id                       as pms_account_id
        , a.is_perform                           as is_perform
        , a.is_moxy                              as is_moxy
        , a.is_intraday_import                   as is_intraday_import
    from {{ ref('fidelity_mwa_history__vw_positd_position') }} as p
    inner join mis_accounts as a
        on p.account_custodial = a.account_number
        and a.is_included = 1
    left join fidelity_core_funds as sweep
        on p.effective_date = sweep.effective_date
        and p.account_custodial = sweep.account_number
        and p.symbol = sweep.ticker
    where 1 = 1
        and p.effective_date in (select t.effective_date from dates as t)
        and is_cash = 1
)

, lots_with_cash as (
    select
        t.effective_date             as effective_date
        , t.custodian                as custodian
        , t.account_number           as account_number
        , t.account_number_formatted as account_number_formatted
        , a.account_number           as crm_account_number
        , a.pms_account_id           as pms_account_id
        , a.is_active                as is_active
        , t.symbol                   as symbol
        , t.ticker                   as ticker
        , t.cusip                    as cusip
        , t.is_sweep                 as is_custodial_cash
        , t.quantity                 as quantity
        , t.current_price            as current_price
        , t.current_value            as current_value
        , t.current_price            as current_price_raw
        , t.current_value            as current_value_raw
        , null::number(20 , 5)       as current_price_unfactored
        , null::number(20 , 5)       as current_value_unfactored
        , null::number(20 , 5)       as factor
        , t.cost_per_share           as cost_per_share
        , t.cost_basis               as cost_basis
        , t.trade_date               as acquired_date
        , null::text                 as product_name
        , null::text                 as product_type
        , null::text                 as product_category
        , null::int                  as product_id
        , null::int                  as asset_id
        , null::int                  as is_asset_managed
        , null::text                 as lot_id
        , a.is_perform               as is_perform
        , a.is_moxy                  as is_moxy
        , a.is_intraday_import       as is_intraday_import
        , t._created_at              as _created_at
    from {{ ref('custodian_tax_lots') }} as t
    inner join mis_accounts as a
        on t.account_number = a.account_number
    where 1 = 1
        and t.effective_date in (select t.effective_date from dates as t)
        and t.custodian in ('fidelity')
        and t.firm_source ilike 'mwa'
        -- Exclude lots which are NIGO. Fidelity can have bad lots
        -- and they provide flags in the data to identify them. How nice.
        and coalesce(t._extra_fields:nigo_out_of_balance_exception_indicator::int , 0) = 0

    union all

    select
        effective_date
        , custodian          as custodian
        , account_number     as account_number
        , null::text         as account_number_formatted
        , crm_account_number as crm_account_number
        , pms_account_id     as pms_account_id
        , is_active          as is_active
        , symbol             as symbol
        , ticker             as ticker
        , cusip              as cusip
        , 1::int             as is_custodial_cash
        , quantity           as quantity
        , 1                  as current_price
        , quantity           as current_value
        , 1                  as current_price_raw
        , quantity           as current_value_raw
        , 1                  as current_price_unfactored
        , quantity           as current_value_unfactored
        , null::text         as factor
        , 1                  as cost_per_share
        , quantity           as cost_basis
        , null::date         as acquired_date
        , null::text         as product_name
        , null::text         as product_type
        , null::text         as product_category
        , null::text         as product_id
        , null::text         as asset_id
        , null::text         as is_asset_managed
        , null::text         as lot_id
        , is_perform         as is_perform
        , is_moxy            as is_moxy
        , is_intraday_import as is_intraday_import
        , _created_at        as _created_at
    from fidelity_sweep

    union all

    select
        effective_date
        , custodian          as custodian
        , account_number     as account_number
        , null::text         as account_number_formatted
        , crm_account_number as crm_account_number
        , pms_account_id     as pms_account_id
        , is_active          as is_active
        , symbol             as symbol
        , ticker             as ticker
        , cusip              as cusip
        , 1::int             as is_custodial_cash
        , quantity           as quantity
        , 1                  as current_price
        , quantity           as current_value
        , 1                  as current_price_raw
        , quantity           as current_value_raw
        , 1                  as current_price_unfactored
        , quantity           as current_value_unfactored
        , null::text         as factor
        , 1                  as cost_per_share
        , quantity           as cost_basis
        , null::date         as acquired_date
        , null::text         as product_name
        , null::text         as product_type
        , null::text         as product_category
        , null::text         as product_id
        , null::text         as asset_id
        , null::text         as is_asset_managed
        , null::text         as lot_id
        , is_perform         as is_perform
        , is_moxy            as is_moxy
        , is_intraday_import as is_intraday_import
        , _created_at        as _created_at
    from fidelity_mmf
)

select *
from lots_with_cash
order by account_number , cusip
