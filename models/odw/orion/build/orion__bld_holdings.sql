{{ config(
    materialized='incremental',
    unique_key='effective_date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    cluster_by=['effective_date', 'fkalclient', 'left(account_number, 2)']
) }}

{%- set start_date = cvar('start_date_orion') -%}
{%- set lookback = cvar('lookback') -%}

select
    v.effective_date                                                             as effective_date
    , a.system_name                                                              as system_name
    , a.system_instance                                                          as system_instance
    , a.system_key                                                               as system_key
    , a.firm_source                                                              as firm_source
    , a.pkaccount                                                                as account_id
    , upper(ass.acctcode)                                                        as account_number_formatted
    , upper(replace(ass.acctcode, '-', ''))              as account_number
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
    , v.calculatedvalue                                                          as market_value
    , v.unitbalance                                                              as quantity
    , v.navprice                                                                 as price
    , null::decimal(19 , 9)                                                      as price_unfactored
    , ppf.factor::decimal(19 , 9)                                                as factor
    , cb.cost_basis                                                              as cost_basis

    , ass.productid                                                              as product_id
    , v.fkasset                                                                  as asset_id

    -- Looks at asset (holding) only
    , ass.assetismanaged::int                                                    as is_asset_managed
    -- Looks as product.
    , prod.is_product_managed::int                                               as is_product_managed

    -- [META]
    , a.fkalclient                                                               as fkalclient
    , current_timestamp()::timestamp_ntz                                         as _created_at
    , v._extracted_at::timestamp_ntz                                             as _source_loaded_at
    , v.createddate                                                              as createddate
    , v._source_file::varchar(200)                                               as _source_file

from {{ ref('orion__base_vw_account') }} as a
inner join {{ ref('orion__base_vw_asset') }} as ass
    on a.fkalclient = ass.fkalclient
    and a.pkaccount = ass.accountid
left join {{ ref('orion__base_vw_assetvalue') }} as v
    on a.fkalclient = v.fkalclient
    and ass.fkasset = v.fkasset
    and a.effective_date = v.effective_date
left join {{ ref('orion__bld_products') }} prod
    on ass.fkalclient = prod.fkalclient
    and ass.productid = prod.product_id
left join {{ ref('orion__base_vw_custodian') }} as cust
    on a.fkalclient = cust.fkalclient
    and a.fkcustodian = cust.pkcustodian
inner join {{ ref('orion__base_vw_registration') }} as reg
    on a.fkalclient = reg.fkalclient
    and a.fkregistration = reg.pkregistration
    and a.effective_date = reg.effective_date
left join {{ ref('orion__base_vw_personal_household') }} as ph
    on reg.fkalclient = ph.hh_fkalclient
    and reg.fkclient = ph.hh_pkclient
left join {{ ref('orion__cost_basis_by_account') }} as cb
    on a.fkalclient = cb.fkalclient
    and ass.fkasset = cb.fkasset
    and a.effective_date = cb.effective_date
left join {{ ref('orion__base_vw_productpricefactor') }} as ppf
    on ass.productid = ppf.fkproduct
    and v.effective_date = ppf.factordate
where 1 = 1
    -- Model start date. This applies for full-refresh.
    and v.effective_date >= '{{ start_date }}'
    {%- if is_incremental() or target.name not in ['prod'] %}
    -- Restrict lookback window if incremental or not prod
    and v.effective_date >= current_date() - {{ lookback }}
    {%- endif %}

    {%- if is_incremental() %}
        -- These are the dates that need added/refreshed.
        and v.effective_date in (
            select aa.effective_date
            from (
                select
                    effective_date
                    , max(createddate) as _created_at
                from {{ ref('orion__base_vw_assetvalue') }}
                where effective_date >= current_date() - {{ lookback }}
                group by 1
            ) as aa
            where aa._created_at > coalesce((select max(createddate) from {{ this }}) , a._created_at - interval '1 day')
        )
    {%- endif %}
order by v.effective_date , a.fkalclient , account_number
