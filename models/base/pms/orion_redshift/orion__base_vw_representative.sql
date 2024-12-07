select
    ci.clientname                              as clientname
    , ci.system_name                           as system_name
    , ci.system_instance                       as system_instance
    , ci.system_key                            as system_key
    , ci.firm_source                           as firm_source
    , a.content:fkalclient::integer            as fkalclient
    , a.content:pkrep::integer                 as pkrep
    , a.content:fkpersonal::integer            as fkpersonal
    , a.content:fkbrokerdealer::integer        as fkbrokerdealer
    , a.content:fkwholesaler::integer          as fkwholesaler
    , a.content:fkpayee::integer               as fkpayee
    , a.content:fkria::integer                 as fkria
    , a.content:fkwholesaler401k::integer      as fkwholesaler401k
    , a.content:fkplanadministrator::integer   as fkplanadministrator
    , a.content:repcreatedby::varchar(40)      as repcreatedby
    , a.content:repcreateddate::date           as repcreateddate
    , a.content:copytorep::boolean::int        as copytorep
    , a.content:isria::boolean::int            as isria
    , a.content:rianame::varchar(100)          as rianame
    , a.content:royaltcode::varchar(5)         as royaltcode
    , a.content:hasadv::boolean::int           as hasadv
    , a.content:hasu4::boolean::int            as hasu4
    , a.content:isactive::boolean::int         as isactive
    , a.content:isdstdwnld::boolean::int       as isdstdwnld
    , a.content:branchid::varchar(50)          as branchid
    , a.content:oldrep_id::integer             as oldrep_id
    , a.content:repno::varchar(5000)           as repno
    , a.content:impdate::date                  as impdate
    , a.content:editeddate::date               as editeddate
    , a.content:editedby::varchar(40)          as editedby
    , a.content:startdate::date                as startdate
    , a.content:repstatus::integer             as repstatus
    , a.content:firmname::varchar(50)          as firmname
    , a.content:actgledgernum::varchar(50)     as actgledgernum
    , a.content:isdefault::boolean::int        as isdefault
    , a.content:importkey::varchar(50)         as importkey
    , a.content:raamount::double precision     as raamount
    , a.content:radate::date                   as radate
    , a.content:israactive::boolean::int       as israactive
    , a.content:represtrict::varchar(150)      as represtrict
    , a.content:firsttransactiondate::date     as firsttransactiondate
    , a.content:fkcustodiandefault::integer    as fkcustodiandefault
    , a.content:custodianportalid::varchar(50) as custodianportalid
    , a.content:createddate::timestamp         as createddate
    , a.effective_at::date                     as effective_date
    , a._pk::varchar(200)                      as _pk

    , a._extracted_at::timestamp_ntz           as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_representative'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                          as _is_full
    , a._created_at::timestamp_ntz             as _created_at
    , a._source_file                           as _source_file
    , a._checksum                              as _checksum
from {{ source('orion', 'vw_representative') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
