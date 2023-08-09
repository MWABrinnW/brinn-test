select
    ci.clientname                          as clientname
  , content:fkalclient::integer            as fkalclient
  , content:pkrep::integer                 as pkrep
  , content:fkpersonal::integer            as fkpersonal
  , content:fkbrokerdealer::integer        as fkbrokerdealer
  , content:fkwholesaler::integer          as fkwholesaler
  , content:fkpayee::integer               as fkpayee
  , content:fkria::integer                 as fkria
  , content:fkwholesaler401k::integer      as fkwholesaler401k
  , content:fkplanadministrator::integer   as fkplanadministrator
  , content:repcreatedby::varchar(40)      as repcreatedby
  , content:repcreateddate::date           as repcreateddate
  , content:copytorep::boolean::int        as copytorep
  , content:isria::boolean::int            as isria
  , content:rianame::varchar(100)          as rianame
  , content:royaltcode::varchar(5)         as royaltcode
  , content:hasadv::boolean::int           as hasadv
  , content:hasu4::boolean::int            as hasu4
  , content:isactive::boolean::int         as isactive
  , content:isdstdwnld::boolean::int       as isdstdwnld
  , content:branchid::varchar(50)          as branchid
  , content:oldrep_id::integer             as oldrep_id
  , content:repno::varchar(5000)           as repno
  , content:impdate::date                  as impdate
  , content:editeddate::date               as editeddate
  , content:editedby::varchar(40)          as editedby
  , content:startdate::date                as startdate
  , content:repstatus::integer             as repstatus
  , content:firmname::varchar(50)          as firmname
  , content:actgledgernum::varchar(50)     as actgledgernum
  , content:isdefault::boolean::int        as isdefault
  , content:importkey::varchar(50)         as importkey
  , content:raamount::double precision     as raamount
  , content:radate::date                   as radate
  , content:israactive::boolean::int       as israactive
  , content:represtrict::varchar(150)      as represtrict
  , content:firsttransactiondate::date     as firsttransactiondate
  , content:fkcustodiandefault::integer    as fkcustodiandefault
  , content:custodianportalid::varchar(50) as custodianportalid
  , content:createddate::timestamp         as createddate
  , a.effective_at::date                   as effective_date
  , a._pk::varchar(200)                    as _pk
  , a._client::int                         as _client
  , a._extracted_at                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_representative'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                        as _is_full
  , a._created_at                          as _created_at
  , a._source_file                         as _source_file
  , a._checksum                            as _checksum
from {{ source('orion', 'vw_representative') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
