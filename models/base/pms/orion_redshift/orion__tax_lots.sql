select
    a.effective_date                                                             as effective_date
    , a.system_name                                                              as system_name
    , a.system_instance                                                          as system_instance
    , a.system_key                                                               as system_key
    , a.firm_source                                                              as firm_source
    -- PMS ---------------------------------------------------------------------
    , a.pkaccount                                                                as account_id
    , upper(ass.acctcode)                                                        as account_number_formatted
    , replace(replace(ltrim(upper(ass.acctcode) , '0') , '-' , '') , '  ' , ' ') as account_number
    , ph.hh_pkclient                                                             as household_id
    , ph.hh_pers_entityname                                                      as household_name
    , cust.name                                                                  as custodian
    , coalesce(prod.ticker , prod.cusip)::text(100)                              as symbol
    , prod.cusip                                                                 as cusip
    , prod.ticker                                                                as ticker
    , case
        when prod.cusip = prod.ticker
            then 1
        else 0
    end::int                                                                     as is_ticker_cusip
    , prod.productname                                                           as product_name
    , prod.producttypename                                                       as product_type
    , pcat.categoryname::text(200)                                               as product_category
    , prod.productclass                                                          as asset_class
    , prod.iscustodialcash                                                       as is_custodial_cash

    , case
        when cb.fkassetcostbasis is not null
            then greatest(
                    coalesce(cb.longtermunits , 0) , coalesce(cb.shorttermunits , 0)
                ) * v.navprice
        else v.calculatedvalue
    end::decimal(20 , 2)                                                         as market_value
    , v.navprice                                                                 as price

    -------------------------------------------------------------------------------

    , cb.acquireddate::date                                                      as acquired_date
    , case when cb.fkassetcostbasis is not null
            then greatest(
                    coalesce(cb.longtermunits , 0) , coalesce(cb.shorttermunits , 0)
                )
        else v.unitbalance
    end::decimal(20 , 3)                                                         as quantity
    , greatest(
        coalesce(cb.longtermcost , 0) , coalesce(cb.shorttermcost , 0)
    )::decimal(20 , 2)                                                           as cost_basis
    , cb.originalcostpershare::decimal(18 , 5)                                   as cost_per_share

    -- Sum of tax lot units
    , sum(coalesce(cb.longtermunits , cb.shorttermunits)) over (
        partition by a._client , v.fkasset
    )::decimal(20 , 4)                                                           as total_cost_basis_quantity
    -- Sum of asset/positions units
    , max(v.unitbalance) over (
        partition by a._client , v.fkasset
    )::decimal(20 , 4)                                                           as total_asset_quantity
    --, ass.pendvalue::decimal(20, 2)                                         as pending_value
    --, ass.pendshares::decimal(20, 4)                                        as pending_shares

    -- PK for the product/security
    , ass.productid                                                              as product_id
    -- PK for the position
    , v.fkasset                                                                  as asset_id
    -- Unique record id for the tax lot
    , cb.fkassetcostbasis::int                                                   as lot_id

    -- Extra source fields for debug or downstream use.
    , null::variant                                                              as extra_fields

    -- [META]
    , a.is_head                                                                  as is_head
    , a.is_current                                                               as is_current
    , current_timestamp::timestamp_ntz                                           as _created_at
    , v._extracted_at::timestamp_ntz                                             as _source_loaded_at
    , v._source_file::varchar(200)                                               as _source_file

from {{ ref('orion__base_vw_account') }} as a
inner join {{ ref('orion__base_vw_asset') }} as ass
    on a._client = ass._client
    and a.pkaccount = ass.accountid
inner join {{ ref('orion__base_vw_assetvalue') }} as v
    on a._client = v._client
    and ass.fkasset = v.fkasset
    and a.effective_date = v.effective_date
inner join {{ ref('orion__base_vw_product') }} as prod
    on a._client = prod._client
    and ass.productid = prod.pkproduct
left join {{ ref('orion__base_vw_productclass') }} as pc
    on prod._client = pc._client
    and prod.fkproductclass = pc.pkproductclass
    and prod.effective_date = pc.effective_date
left join {{ ref('orion__base_vw_productcategory') }} as pcat
    on pc._client = pcat._client
    and pc.fkproductcategory = pcat.pkproductcategory
    and pc.effective_date = pcat.effective_date
left join {{ ref('orion__base_vw_custodian') }} as cust
    on a._client = cust._client
    and a.fkcustodian = cust.pkcustodian
inner join {{ ref('orion__base_vw_registration') }} as reg
    on a._client = reg._client
    and a.fkregistration = reg.pkregistration
    and a.effective_date = reg.effective_date
left join {{ ref('orion__base_vw_personal_household') }} as ph
    on reg._client = ph._client
    and reg.fkclient = ph.hh_pkclient
left join {{ ref('orion__base_vw_costbasisunrealized') }} as cb
    on a._client = cb._client
    and ass.fkasset = cb.fkasset
    and a.effective_date = cb.effective_date
where 1 = 1
