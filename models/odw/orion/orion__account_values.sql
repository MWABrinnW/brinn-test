select
    a.system_name                             as system_name
    , a.system_instance                       as system_instance
    , a.system_key                            as system_key
    , a.firm_source                           as firm_source
    , v.asofdate                              as effective_date
    , a.fkalclient                            as fkalclient
    , a.pkaccount                             as account_id
    , upper(replace(a.acctcode , '-' , ''))   as account_number
    , a.fkregistration                        as registration_id
    , sum(v.calculatedvalue)::decimal(38 , 7) as market_value
    , sum(v.calculatedvalue)::decimal(38 , 7) as aum
    , sum(
        case
            when prod.product_class_category = 'M' then v.calculatedvalue
            else 0
        end
    )::decimal(38 , 7)                        as cash
    , sum(
        case
            when prod.is_custodial_cash = 1 then v.calculatedvalue
            else 0
        end
    )::decimal(38 , 7)                        as mmcash
    , max(v.createddate)                      as createddate
    , {{ col_is_head(
        reference=ref('orion__base_vw_assetvalue'),
        source_date_col='v.effective_date',
        reference_date_col='effective_date'
        ) }}
    , max(v._created_at)                      as _created_at
    , max(v._extracted_at)                    as _extracted_at
    , max(v._source_loaded_at)                as _source_loaded_at
from {{ ref('orion__base_vw_account') }} as a
inner join {{ ref('orion__base_vw_asset') }} as ass
    on a.fkalclient = ass.fkalclient
    and a.pkaccount = ass.accountid
inner join {{ ref('orion__base_vw_assetvalue') }} as v
    on ass.fkalclient = v.fkalclient
    and ass.fkasset = v.fkasset
left join {{ ref('orion__bld_products') }} as prod
    on ass.fkalclient = prod.fkalclient
    and ass.productid = prod.product_id
where true
    and a.is_head = 1
group by all
