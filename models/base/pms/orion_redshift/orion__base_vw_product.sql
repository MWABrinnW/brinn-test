{{ config(
    materialized='incremental',
    cluster_by=['fkalclient', 'trunc(pkproduct, -5)'],
    unique_key=['fkalclient', 'pkproduct'],
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns'
) }}

with cte_records_to_update as (
    select
        a.content:pkproduct::integer    as pkproduct
        , a.content:fkalclient::integer as fkalclient
    from {{ source('orion', 'vw_product') }} as a
    {% if is_incremental() -%}
        left join {{ this }} as b
            on a.content:fkalclient::int = b.fkalclient
            and a.content:pkproduct::int = b.pkproduct
        where 1 = 1
            and (
                a.content:createddate::timestamp > b.createddate
                or b.pkproduct is null
            )
    {% endif -%}
)

select
    ci.clientname                                              as clientname
    , ci.system_name                                           as system_name
    , ci.system_instance                                       as system_instance
    , ci.system_key                                            as system_key
    , ci.firm_source                                           as firm_source
    , a.content:fkalclient::integer                            as fkalclient
    , a.content:pkproduct::integer                             as pkproduct
    , a.content:fkfundfamily::integer                          as fkfundfamily
    , a.content:prodcreateddate::date                          as prodcreateddate
    , a.content:prodcreatedby::varchar(50)                     as prodcreatedby
    , a.content:ticker::varchar(50)                            as ticker
    , a.content:currprice::double precision                    as currprice
    , a.content:currpricedate::date                            as currpricedate
    , a.content:cusip::varchar(50)                             as cusip
    , a.content:isactive::boolean::int                         as isactive
    , a.content:productname::varchar(150)                      as productname
    , a.content:editeddate::date                               as editeddate
    , a.content:editedby::varchar(50)                          as editedby
    , a.content:oldrecid::varchar(10)                          as oldrecid
    , a.content:oldlrecid::varchar(10)                         as oldlrecid
    , a.content:fkshareclass::integer                          as fkshareclass
    , a.content:apccode::varchar(20)                           as apccode
    , a.content:micropalcode::varchar(20)                      as micropalcode
    , a.content:defaultprice::double precision                 as defaultprice
    , a.content:isdefault::boolean::int                        as isdefault
    , a.content:convschsells::boolean::int                     as convschsells
    , a.content:producttype::integer                           as producttype
    , a.content:producttypename::varchar(50)                   as producttypename
    , a.content:fundnumber::varchar(20)                        as fundnumber
    , a.content:isusepricetime::boolean::int                   as isusepricetime
    , a.content:tradecutofftime::timestamp                     as tradecutofftime
    , a.content:estimatereporttime::timestamp                  as estimatereporttime
    , a.content:estimateinterval::integer                      as estimateinterval
    , a.content:stfdays::integer                               as stfdays
    , a.content:stfperc::double precision                      as stfperc
    , a.content:tradesperday::integer                          as tradesperday
    , a.content:stblockdays::integer                           as stblockdays
    , a.content:fkproducttype::integer                         as fkproducttype
    , a.content:estdivfrequency::double precision              as estdivfrequency
    , a.content:is144a::boolean::int                           as is144a
    , a.content:fkproductparent::integer                       as fkproductparent
    , a.content:pricestatus::integer                           as pricestatus
    , a.content:fksubholding::integer                          as fksubholding
    , a.content:strikeprice::double precision                  as strikeprice
    , a.content:expirationdate::date                           as expirationdate
    , a.content:optionlotsize::integer                         as optionlotsize
    , a.content:isderivative::boolean::int                     as isderivative
    , a.content:includebydefault::boolean::int                 as includebydefault
    , a.content:allowincomeoverride::boolean::int              as allowincomeoverride
    , a.content:excludefromcb::boolean::int                    as excludefromcb
    , a.content:tickeriscusip::integer                         as tickeriscusip
    , a.content:isdividendsuspended::boolean::int              as isdividendsuspended
    , a.content:fkproductclass::integer                        as fkproductclass
    , a.content:productclass::varchar()                        as productclass
    , a.content:fkriskcategory::integer                        as fkriskcategory
    , a.content:isdisabled::boolean::int                       as isdisabled
    , a.content:productstatus::integer                         as productstatus
    , a.content:fkbondrating::integer                          as fkbondrating
    , a.content:fkproductriskalt::integer                      as fkproductriskalt
    , a.content:isautoassign::boolean::int                     as isautoassign
    , a.content:isused::integer                                as isused
    , a.content:fkbondrating2::integer                         as fkbondrating2
    , a.content:iscustodialcash::boolean::int                  as iscustodialcash
    , a.content:ismanaged::boolean::int                        as ismanaged
    , a.content:allowintradayperformance::boolean::int         as allowintradayperformance
    , a.content:hasfees::boolean::int                          as hasfees
    , a.content:useglobalsetting::boolean::int                 as useglobalsetting
    , a.content:isfederallytaxable::boolean::int               as isfederallytaxable
    , a.content:isstatetaxable::boolean::int                   as isstatetaxable
    , a.content:uselocalpricesonly::boolean::int               as uselocalpricesonly
    , a.content:color::varchar(50)                             as color
    , a.content:annualincomerate::double precision             as annualincomerate
    , a.content:paymentfrequency::integer                      as paymentfrequency
    , a.content:fkadvassetcategory::integer                    as fkadvassetcategory
    , a.content:isadvreportable::boolean::int                  as isadvreportable
    , a.content:is13freportable::boolean::int                  as is13freportable
    , a.content:usedailyinterestaccrual::boolean::int
        as usedailyinterestaccrual
    , a.content:excludebondaccrualfromvaluations::boolean::int
        as excludebondaccrualfromvaluations
    , a.content:productnameoverride::varchar(150)
        as productnameoverride
    , a.content:createddate::timestamp                         as createddate
    , max(ed.prior_market_date) over (partition by 1)          as effective_date
    , a._pk::varchar(200)                                      as _pk
    , a._extracted_at::timestamp_ntz                           as _extracted_at
    , case
        when ed.prior_market_date = max(ed.prior_market_date) over (partition by 1 = 1)
            then 1
        else 0
    end                                                        as is_head
    , a._is_full::int                                          as _is_full
    , a._created_at::timestamp_ntz                             as _created_at
    , a._source_file                                           as _source_file
    , a._checksum                                              as _checksum
from {{ source('orion', 'vw_product') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
left join {{ ref('dates') }} as ed
    on a._extracted_at::date = ed.date_key
{% if is_incremental() -%}
    inner join cte_records_to_update as rtu
        on a.content:fkalclient::int = rtu.fkalclient
        and a.content:pkproduct::int = rtu.pkproduct
{% endif -%}
where 1 = 1
order by a.content:fkalclient::int , a.content:pkproduct::int
