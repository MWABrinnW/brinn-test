with mis_accounts as (
    select
        account_number
        , account_number_formatted
        , pms_account_id
        , custodian
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
        , (select max(t.effective_date) from {{ ref('custodian_tax_lots') }} as t)
    )::date as effective_date
)

, schwab_sweep_raw as (
    select
        c.effective_date                                                               as effective_date
        , c.account_number                                                             as account_number
        , c.net_credit_or_debit_settled_unsettled + c.margin_balance_settled_unsettled as sweep_value
        , c._source_loaded_at                                                          as _created_at
    from {{ ref('schwab__base_cash') }} as c
    inner join mis_accounts as a
        on c.account_number = a.account_number
    where 1 = 1
        and c.effective_date in (select t.effective_date from dates as t)
        and c.rn_global = 1
)

, schwab_sweep as (
    -- Schwab presents cash as a non-security holding so it doesn't
    -- appear in the tax lots dataset or holdings. However, money market funds
    -- (SNAXX) do appear in the tax lots data (but not SWGXX).
    -- Fidelity doesn't have a non-security cash position, instead
    -- representing all cash within a MMF security position (like FDRXX).
    select
        max(c.effective_date)                          as effective_date
        , 'schwab'                                     as custodian
        , a.account_number                             as account_number
        , a.pms_account_id                             as pms_account_id
        , a.account_number                             as crm_account_number
        , a.is_active                                  as is_active
        , a.is_perform                                 as is_perform
        , a.is_moxy                                    as is_moxy
        , a.is_intraday_import                         as is_intraday_import
        , 'SchwabCash'::text                           as symbol
        , 'SchwabCash'::text                           as ticker
        , 'SchwabCash'::text                           as cusip
        , coalesce(c.sweep_value , 0)::decimal(15 , 2) as quantity
        , c._created_at                                as _created_at
    from mis_accounts as a
    left join schwab_sweep_raw as c
        on a.account_number = c.account_number
    where 1 = 1
        -- We need(?) to create a cash record even if it's zero balance and not in the
        -- upstream schwab data. At least, that behavior mimics Orion.
        and (c.account_number is not null or a.custodian ilike '%schwab%')
    group by all
)

, schwab_mmf_sweep as (
    -- We need to capture SWGXX which auto liquidates. It's an MMF position
    -- but does not appear in the lots files.
    select
        max(p.effective_date)                                                 as effective_date
        , 'schwab'                                                            as custodian
        , a.account_number                                                    as account_number
        , a.pms_account_id                                                    as pms_account_id
        , a.account_number                                                    as crm_account_number
        , a.is_active                                                         as is_active
        , a.is_perform                                                        as is_perform
        , a.is_moxy                                                           as is_moxy
        , a.is_intraday_import                                                as is_intraday_import
        , p.ticker_symbol::text                                               as symbol
        , p.ticker_symbol::text                                               as ticker
        , p.cusip::text                                                       as cusip
        , coalesce(p.market_value_settled_and_unsettled , 0)::decimal(15 , 2) as quantity
        , p._source_loaded_at                                                 as _created_at
    from mis_accounts as a
    inner join {{ ref('schwab__base_positions') }} as p
        on a.account_number = p.account_number
        and p.effective_date in (select t.effective_date from dates as t)
        and p.rn_global = 1
        and p.ticker_symbol = 'SWGXX'
    where 1 = 1
    group by all
)

, lots_with_cash as (
    -- Lots without Schwab MMF which we need to collapse separately.
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
        and t.effective_date in (select tt.effective_date from dates as tt)
        and t.rn_global = 1
        and t.custodian in ('schwab')
        -- Exclude schwab MMF because we will collapse them, as Orion does.
        and coalesce(t.product_type_source_code , '') <> 'MMN'

    union all

    -- Schwab MMF collapsed. (i.e. SNOXX, SWVXX)
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
        , sum(t.quantity)            as quantity
        , sum(t.current_price)       as current_price
        , sum(t.current_value)       as current_value
        , sum(t.current_price)       as current_price_raw
        , sum(t.current_value)       as current_value_raw
        , null::number(20 , 5)       as current_price_unfactored
        , null::number(20 , 5)       as current_value_unfactored
        , null::number(20 , 5)       as factor
        , null::decimal(20 , 5)      as cost_per_share
        , 0::decimal(20 , 2)         as cost_basis
        , null::date                 as acquired_date
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
        , max(t._created_at)         as _created_at
    from {{ ref('custodian_tax_lots') }} as t
    inner join mis_accounts as a
        on t.account_number = a.account_number
    where 1 = 1
        and t.effective_date in (select tt.effective_date from dates as tt)
        and t.rn_global = 1
        and t.custodian in ('schwab')
        and t.firm_source ilike 'mwa'
        and coalesce(t.product_type_source_code , '') = 'MMN'
    group by all

    union all

    -- Raw sweep cash
    select
        effective_date       as effective_date
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
    from schwab_sweep

    union all

    -- Auto liquidating MMF (SWGXX)
    select
        effective_date       as effective_date
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
    from schwab_mmf_sweep
)

select *
from lots_with_cash
order by account_number , cusip
