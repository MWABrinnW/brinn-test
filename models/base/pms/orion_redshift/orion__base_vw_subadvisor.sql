select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:fkalclient::integer               as fkalclient
    , a.content:pksubadvisor::integer             as pksubadvisor
    , a.content:fkpersonal::integer               as fkpersonal
    , a.content:fkpayee::integer                  as fkpayee
    , a.content:isactive::boolean::int            as isactive
    , a.content:sacode::varchar(150)              as sacode
    , a.content:description::varchar(65535)       as description
    , a.content:masteracctcode::varchar(60)       as masteracctcode
    , a.content:fksubadvisorglobal::integer       as fksubadvisorglobal
    , a.content:gettargetallocemail::boolean::int as gettargetallocemail
    , a.content:targetallocemails::varchar(65535) as targetallocemails
    , a.content:eclipsefirmid::integer            as eclipsefirmid
    , a.content:subadvisorcreateddate::date       as subadvisorcreateddate
    , a.content:subadvisorcreatedby::varchar(60)  as subadvisorcreatedby
    , a.content:editeddate::date                  as editeddate
    , a.content:editedby::varchar(60)             as editedby
    , a.content:createddate::timestamp            as createddate
    , a.effective_at::date                        as effective_date
    , a._pk::varchar(200)                         as _pk

    , a._extracted_at::timestamp_ntz              as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_subadvisor'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                             as _is_full
    , a._created_at::timestamp_ntz                as _created_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_subadvisor') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
