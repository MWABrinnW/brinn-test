{{ config(
    materialized = 'incremental',
    cluster_by=['effective_date', 'account_number'],
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

{%- set lookback = cvar('lookback') -%}
{%- set dev_filter = cvar('dev_day_filter') -%}
{%- set max_lookback = 10 -%}


with cte_max_createddate as (
    {% if is_incremental() -%}
    select max(createddate) as max_createddate from {{ this }}
    {% else -%}
    select null::timestamp_tz as max_createddate
    {% endif -%}
)

, cte_effective_dates_to_refresh as (
    select distinct effective_date
    from {{ ref('orion__base_vw_costbasisunrealized') }}
    where 1=1
        -- Max lookback for a full refresh.
        and effective_date >= current_date() - {{ max_lookback }}
        {%- if target.name not in ['prod'] %}
            -- Restrict lookback window in dev.
            and effective_date >= current_date() - {{ dev_filter }}
        {%- endif %}
        {%- if is_incremental() %}
            -- Restrict lookback for incremental run.
            and effective_date >= current_date() - {{ lookback }}
            -- These records will scope the dates that are flagged for add/refresh.
            and createddate > (select max_createddate from cte_max_createddate)
        {%- endif %}
)

, cte_asset_value as (
    select fkalclient, fkasset, effective_date, unitbalance, calculatedvalue, navprice, createddate
    from {{ ref('orion__base_vw_assetvalue') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_effective_dates_to_refresh)
)

, cte_cost_basis as (
    select fkalclient, fkasset, effective_date, createddate, _created_at
        , _extracted_at, _source_file, fkassetcostbasis, longtermunits, shorttermunits
        , acquireddate, longtermcost, shorttermcost, originalcostpershare
    from {{ ref('orion__base_vw_costbasisunrealized') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_effective_dates_to_refresh)
)

, cte_product_price_factor as (
    select fkproduct, factordate, factor
    from {{ ref('orion__base_vw_productpricefactor') }}
    where 1 = 1
        and factordate in (select effective_date from cte_effective_dates_to_refresh)
)

, cte_registration as (
    select fkalclient, effective_date, pkregistration, fkclient
    from {{ ref('orion__base_vw_registration') }}
    where 1 = 1
        and effective_date in (select effective_date from cte_effective_dates_to_refresh)
)

, cte_personal_household as (
    select hh_fkalclient, hh_pkclient, hh_pers_entityname
    from {{ ref('orion__base_vw_personal_household') }}
    where 1 = 1
        --and effective_date in (select effective_date from cte_effective_dates_to_refresh)
)


select
    a.effective_date                                                             as effective_date
    , a.system_name                                                              as system_name
    , a.system_instance                                                          as system_instance
    , a.system_key                                                               as system_key
    , a.firm_source                                                              as firm_source
    , a.pkaccount                                                                as account_id
    , replace(replace(ltrim(upper(ass.acctcode) , '0') , '-' , '') , '  ' , ' ') as account_number
    , upper(ass.acctcode)                                                        as account_number_formatted
    , ph.hh_pkclient                                                             as household_id
    , ph.hh_pers_entityname                                                      as household_name
    , cust.name                                                                  as custodian
    , prod.symbol                                                                as symbol
    , prod.cusip                                                                 as cusip
    , prod.ticker                                                                as ticker
    , prod.is_ticker_cusip                                                       as is_ticker_cusip
    , prod.is_custodial_cash                                                     as is_custodial_cash
    , prod.product_name                                                          as product_name
    , prod.product_type                                                          as product_type
    , prod.product_category                                                      as product_category
    , prod.asset_class                                                           as asset_class

    , case when cb.fkassetcostbasis is not null
            then greatest_ignore_nulls(
                    coalesce(nullif(cb.longtermunits , 0) , nullif(cb.shorttermunits , 0) , 0)
                )
    end::decimal(20 , 4)                                                         as lot_quantity
    , v.navprice                                                                 as current_price
    , case
        when cb.fkassetcostbasis is not null
            then greatest_ignore_nulls(
                    coalesce(nullif(cb.longtermunits , 0) , nullif(cb.shorttermunits , 0) , 0)
                ) * v.navprice
    end::decimal(20 , 2)                                                         as lot_value
    , ppf.factor::decimal(20 , 12)                                               as factor
    -- Looks at asset (holding) only
    , ass.assetismanaged::int                                                    as is_asset_managed
    -- Looks as product.
    , prod.is_product_managed::int                                               as is_product_managed

    -------------------------------------------------------------------------------

    , cb.acquireddate::date                                                      as acquired_date
    , greatest_ignore_nulls(
        coalesce(nullif(cb.longtermcost , 0) , nullif(cb.shorttermcost , 0) , 0)
    )::decimal(20 , 2)                                                           as cost_basis
    , case
        when upper(prod.product_type) = 'CD'
            and lower(cust.name) = 'schwab'
            and cb.originalcostpershare > 0
            then cb.originalcostpershare / 100
        when cb.originalcostpershare > 0
            then cb.originalcostpershare
        when lot_quantity > 0
            then (cost_basis / lot_quantity)
    end::decimal(20 , 5)                                                         as cost_per_share

    -- Yet to see if these ever show with value. What would we need them for?
    , ass.pendvalue::decimal(20 , 2)                                             as pending_value
    , ass.pendshares::decimal(20 , 4)                                            as pending_shares

    -- Sum of tax lot units
    , sum(lot_quantity) over (
        partition by cb.effective_date, ass.fkalclient , a.pkaccount , ass.fkasset
    )::decimal(20 , 4)                                                           as aggregate_lot_quantity
    -- Sum of asset/positions units
    , max(v.unitbalance) over (
        partition by v.effective_date, ass.fkalclient , a.pkaccount , ass.fkasset
    )::decimal(20 , 4)                                                           as aggregate_asset_quantity
    -- Sum of lot market value
    , sum(lot_value) over (
        partition by cb.effective_date, ass.fkalclient , a.pkaccount , ass.fkasset
    )::decimal(20 , 2)                                                           as aggregate_lot_value
    -- Sum of asset/positions calculated value
    , max(v.calculatedvalue) over (
        partition by v.effective_date, ass.fkalclient , a.pkaccount , ass.fkasset
    )::decimal(20 , 2)                                                           as aggregate_asset_value
    , (aggregate_lot_quantity = aggregate_asset_quantity)::int                   as is_quantity_match
    , (aggregate_lot_value = aggregate_asset_value)::int                         as is_value_match


    , ass.productid                                                              as product_id
    , ass.fkasset                                                                as asset_id
    , cb.fkassetcostbasis::int                                                   as lot_id
    , a.fkalclient                                                               as fkalclient

    , ass.lastrecondate                                                          as last_recon_date
    , ass.expectedrecondate                                                      as expected_recon_date

    -- Extra source fields for debug or downstream use.
    , null::variant                                                              as extra_fields

    -- [META]
    , coalesce(
        cb.createddate , v.createddate , v.createddate , a.createddate
    )::timestamp                                                                 as createddate
    , current_timestamp()::timestamp_ntz                                         as _created_at
    , cb._extracted_at                                                           as _extracted_at
    , cb._created_at::timestamp_ntz                                              as _source_loaded_at
    , cb._source_file::varchar(200)                                              as _source_file
from {{ ref('orion__base_vw_account') }} as a
inner join {{ ref('orion__base_vw_asset') }} as ass
    on a.fkalclient = ass.fkalclient
    and a.pkaccount = ass.accountid
left join cte_asset_value as v
    on ass.fkalclient = v.fkalclient
    and ass.fkasset = v.fkasset
    and a.effective_date = v.effective_date
left join {{ ref('orion__bld_products') }} prod
    on ass.fkalclient = prod.fkalclient
    and ass.productid = prod.product_id
left join {{ ref('orion__base_vw_custodian') }} as cust
    on a.fkalclient = cust.fkalclient
    and a.fkcustodian = cust.pkcustodian
inner join cte_registration as reg
    on a.fkalclient = reg.fkalclient
    and a.fkregistration = reg.pkregistration
    and a.effective_date = reg.effective_date
left join cte_personal_household as ph
    on reg.fkalclient = ph.hh_fkalclient
    and reg.fkclient = ph.hh_pkclient
left join cte_cost_basis as cb
    on ass.fkalclient = cb.fkalclient
    and ass.fkasset = cb.fkasset
    --and ass.effective_date = cb.effective_date
    and v.effective_date = cb.effective_date
left join cte_product_price_factor as ppf
    on ass.productid = ppf.fkproduct
    and v.effective_date = ppf.factordate
where 1 = 1
    -- Max lookback for a full refresh.
    and a.effective_date >= current_date() - {{ max_lookback }}
    {%- if target.name not in ['prod'] %}
        -- Restrict lookback window in dev.
        and a.effective_date >= current_date() - {{ dev_filter }}
    {%- endif %}

    {%- if is_incremental() %}
        -- Restrict lookback for incremental run.
        and a.effective_date >= current_date() - {{ lookback }}
        -- These are the dates that need added/refreshed.
        and a.effective_date in (
            select effective_date from cte_effective_dates_to_refresh
        )
    {%- endif %}
order by a.effective_date , account_number
