select
    v.asofdate                                                                                   as effective_date
  , a._client                                                                                    as _client
  , a.pkaccount                                                                                  as pkaccount
  , ltrim(upper(replace(a.acctcode, '-', '')), '0')                                              as account_number
  , a.fkregistration                                                                             as fkregistration
  , sum(v.calculatedvalue)::decimal(38, 7)                                                       as market_value
  , sum(v.calculatedvalue)::decimal(38, 7)                                                       as aum
  , sum(case when pc.category = 'M' then v.calculatedvalue else 0 end)::decimal(38, 7)           as cash
  , sum(case when pext.iscustodialcash = true then v.calculatedvalue else 0 end)::decimal(38, 7) as mmcash
from {{ ref('orion__base_vw_account') }}      a
join {{ ref('orion__base_vw_asset') }}        ass
     on a._client = ass._client
         and a.pkaccount = ass.accountid
join {{ ref('orion__base_vw_assetvalue') }}   v
     on ass._client = v._client
         and ass.fkasset = v.fkasset
join {{ ref('orion__base_vw_product') }}      pext
     on ass._client = pext._client
         and ass.productid = pext.pkproduct
join {{ ref('orion__base_vw_productclass') }} pc
     on pext._client = pc._client
         and pc.pkproductclass = pext.fkproductclass
where true
  and a.is_head = 1
group by 1, 2, 3, 4, 5
