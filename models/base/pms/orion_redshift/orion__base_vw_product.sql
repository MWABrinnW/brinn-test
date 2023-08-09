select
    ci.clientname                                                                                          as clientname
  , content:fkalclient::integer                                                                            as fkalclient
  , content:pkproduct::integer                                                                             as pkproduct
  , content:fkfundfamily::integer                                                                          as fkfundfamily
  , content:prodcreateddate::date                                                                          as prodcreateddate
  , content:prodcreatedby::varchar(50)                                                                     as prodcreatedby
  , content:ticker::varchar(50)                                                                            as ticker
  , content:currprice::double precision                                                                    as currprice
  , content:currpricedate::date                                                                            as currpricedate
  , content:cusip::varchar(50)                                                                             as cusip
  , content:isactive::boolean::int                                                                         as isactive
  , content:productname::varchar(150)                                                                      as productname
  , content:editeddate::date                                                                               as editeddate
  , content:editedby::varchar(50)                                                                          as editedby
  , content:oldrecid::varchar(10)                                                                          as oldrecid
  , content:oldlrecid::varchar(10)                                                                         as oldlrecid
  , content:fkshareclass::integer                                                                          as fkshareclass
  , content:apccode::varchar(20)                                                                           as apccode
  , content:micropalcode::varchar(20)                                                                      as micropalcode
  , content:defaultprice::double precision                                                                 as defaultprice
  , content:isdefault::boolean::int                                                                        as isdefault
  , content:convschsells::boolean::int                                                                     as convschsells
  , content:producttype::integer                                                                           as producttype
  , content:producttypename::varchar(50)                                                                   as producttypename
  , content:fundnumber::varchar(20)                                                                        as fundnumber
  , content:isusepricetime::boolean::int                                                                   as isusepricetime
  , content:tradecutofftime::timestamp                                                                     as tradecutofftime
  , content:estimatereporttime::timestamp                                                                  as estimatereporttime
  , content:estimateinterval::integer                                                                      as estimateinterval
  , content:stfdays::integer                                                                               as stfdays
  , content:stfperc::double precision                                                                      as stfperc
  , content:tradesperday::integer                                                                          as tradesperday
  , content:stblockdays::integer                                                                           as stblockdays
  , content:fkproducttype::integer                                                                         as fkproducttype
  , content:estdivfrequency::double precision                                                              as estdivfrequency
  , content:is144a::boolean::int                                                                           as is144a
  , content:fkproductparent::integer                                                                       as fkproductparent
  , content:pricestatus::integer                                                                           as pricestatus
  , content:fksubholding::integer                                                                          as fksubholding
  , content:strikeprice::double precision                                                                  as strikeprice
  , content:expirationdate::date                                                                           as expirationdate
  , content:optionlotsize::integer                                                                         as optionlotsize
  , content:isderivative::boolean::int                                                                     as isderivative
  , content:includebydefault::boolean::int                                                                 as includebydefault
  , content:allowincomeoverride::boolean::int                                                              as allowincomeoverride
  , content:excludefromcb::boolean::int                                                                    as excludefromcb
  , content:tickeriscusip::integer                                                                         as tickeriscusip
  , content:isdividendsuspended::boolean::int                                                              as isdividendsuspended
  , content:fkproductclass::integer                                                                        as fkproductclass
  , content:productclass::varchar()                                                                        as productclass
  , content:fkriskcategory::integer                                                                        as fkriskcategory
  , content:isdisabled::boolean::int                                                                       as isdisabled
  , content:productstatus::integer                                                                         as productstatus
  , content:fkbondrating::integer                                                                          as fkbondrating
  , content:fkproductriskalt::integer                                                                      as fkproductriskalt
  , content:isautoassign::boolean::int                                                                     as isautoassign
  , content:isused::integer                                                                                as isused
  , content:fkbondrating2::integer                                                                         as fkbondrating2
  , content:iscustodialcash::boolean::int                                                                  as iscustodialcash
  , content:ismanaged::boolean::int                                                                        as ismanaged
  , content:allowintradayperformance::boolean::int                                                         as allowintradayperformance
  , content:hasfees::boolean::int                                                                          as hasfees
  , content:useglobalsetting::boolean::int                                                                 as useglobalsetting
  , content:isfederallytaxable::boolean::int                                                               as isfederallytaxable
  , content:isstatetaxable::boolean::int                                                                   as isstatetaxable
  , content:uselocalpricesonly::boolean::int                                                               as uselocalpricesonly
  , content:color::varchar(50)                                                                             as color
  , content:annualincomerate::double precision                                                             as annualincomerate
  , content:paymentfrequency::integer                                                                      as paymentfrequency
  , content:fkadvassetcategory::integer                                                                    as fkadvassetcategory
  , content:isadvreportable::boolean::int                                                                  as isadvreportable
  , content:is13freportable::boolean::int                                                                  as is13freportable
  , content:usedailyinterestaccrual::boolean::int                                                          as usedailyinterestaccrual
  , content:excludebondaccrualfromvaluations::boolean::int                                                 as excludebondaccrualfromvaluations
  , content:productnameoverride::varchar(150)                                                              as productnameoverride
  , content:cusip::varchar(50)                                                                             as cusip
  , content:createddate::timestamp                                                                         as createddate
  , max(ed.prior_market_date) over (partition by 1)                                                        as effective_date
  , a._pk::varchar(200)                                                                                    as _pk
  , a._client::int                                                                                         as _client
  , a._extracted_at                                                                                        as _extracted_at
  , case when ed.prior_market_date = max(ed.prior_market_date) over (partition by 1 = 1) then 1 else 0 end as is_head
  , {{ col_is_current(date_col='max(ed.prior_market_date) over (partition by 1 = 1)') }}
  , a._is_full::int                                                                                        as _is_full
  , a._created_at                                                                                          as _created_at
  , a._source_file                                                                                         as _source_file
  , a._checksum                                                                                            as _checksum
from {{ source('orion', 'stg_vw_product') }}     a
join      {{ ref('orion__base_vw_clientinfo') }} ci
          on a._client::int = ci.pkalclient
left join {{ ref('dates') }}                     ed
          on a._extracted_at::date = ed.date_key
