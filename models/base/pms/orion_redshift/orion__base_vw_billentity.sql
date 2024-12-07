select
    ci.clientname                                as clientname
    , ci.system_name                             as system_name
    , ci.system_instance                         as system_instance
    , ci.system_key                              as system_key
    , ci.firm_source                             as firm_source
    , a.content:fkalclient::integer              as fkalclient
    , a.content:pkbillentity::integer            as pkbillentity
    , a.content:sentityname::varchar(30)         as sentityname
    , a.content:sentitydesc::varchar(300)        as sentitydesc
    , a.content:ispayableentity::boolean::int    as ispayableentity
    , a.content:isuseradded::boolean::int        as isuseradded
    , a.content:fkbillentityglobal::integer      as fkbillentityglobal
    , a.content:fkpayee::integer                 as fkpayee
    , a.content:isactive::boolean::int           as isactive
    , a.content:isapplytoastro::boolean::int     as isapplytoastro
    , a.content:fkdefaultcollectfrom::integer    as fkdefaultcollectfrom
    , a.content:billentitycreatedby::varchar(60) as billentitycreatedby
    , a.content:billentitycreateddate::date      as billentitycreateddate
    , a.content:editedby::varchar(60)            as editedby
    , a.content:editeddate::date                 as editeddate
    , a.content:createddate::timestamp           as createddate
    , a.effective_at::date                       as effective_date
    , a._pk::varchar(200)                        as _pk

    , a._extracted_at::timestamp_ntz             as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billentity'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                            as _is_full
    , a._created_at::timestamp_ntz               as _created_at
    , a._source_file                             as _source_file
    , a._checksum                                as _checksum
from {{ source('orion', 'vw_billentity') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
