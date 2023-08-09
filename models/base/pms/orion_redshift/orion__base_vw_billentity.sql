select
    ci.clientname                            as clientname
  , content:fkalclient::integer              as fkalclient
  , content:pkbillentity::integer            as pkbillentity
  , content:sentityname::varchar(30)         as sentityname
  , content:sentitydesc::varchar(300)        as sentitydesc
  , content:ispayableentity::boolean::int    as ispayableentity
  , content:isuseradded::boolean::int        as isuseradded
  , content:fkbillentityglobal::integer      as fkbillentityglobal
  , content:fkpayee::integer                 as fkpayee
  , content:isactive::boolean::int           as isactive
  , content:isapplytoastro::boolean::int     as isapplytoastro
  , content:fkdefaultcollectfrom::integer    as fkdefaultcollectfrom
  , content:billentitycreatedby::varchar(60) as billentitycreatedby
  , content:billentitycreateddate::date      as billentitycreateddate
  , content:editedby::varchar(60)            as editedby
  , content:editeddate::date                 as editeddate
  , content:createddate::timestamp           as createddate
  , a.effective_at::date                     as effective_date
  , a._pk::varchar(200)                      as _pk
  , a._client::int                           as _client
  , a._extracted_at                          as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_billentity'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                          as _is_full
  , a._created_at                            as _created_at
  , a._source_file                           as _source_file
  , a._checksum                              as _checksum
from {{ source('orion', 'stg_vw_billentity') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
