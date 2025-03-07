select
    v.asofdate                                                                                      as effective_date
    , a.system_name                                                                                 as system_name
    , a.system_instance                                                                             as system_instance
    , a.system_key
    , a.firm_source
    , a.fkalclient                                                                                  as fkalclient
    , a.pkaccount                                                                                   as pkaccount
    , ltrim(upper(replace(a.acctcode , '-' , '')) , '0')                                            as account_number
    , a.fkregistration                                                                              as fkregistration
    , sum(v.calculatedvalue)::decimal(38 , 7)                                                       as market_value
    , sum(v.calculatedvalue)::decimal(38 , 7)                                                       as aum
    , sum(case when pc.category = 'M' then v.calculatedvalue else 0 end)::decimal(38 , 7)           as cash
    , sum(case when pext.iscustodialcash = true then v.calculatedvalue else 0 end)::decimal(38 , 7) as mmcash
from {{ ref('orion__base_vw_account') }} as a
inner join {{ ref('orion__base_vw_asset') }} as ass
    on a.fkalclient = ass.fkalclient
    and a.pkaccount = ass.accountid
inner join {{ ref('orion__base_vw_assetvalue') }} as v
    on ass.fkalclient = v.fkalclient
    and ass.fkasset = v.fkasset
inner join {{ ref('orion__base_vw_product') }} as pext
    on ass.fkalclient = pext.fkalclient
    and ass.productid = pext.pkproduct
inner join {{ ref('orion__base_vw_productclass') }} as pc
    on pext.fkalclient = pc.fkalclient
    and pext.fkproductclass = pc.pkproductclass
where true
    and a.is_head = 1
group by all
