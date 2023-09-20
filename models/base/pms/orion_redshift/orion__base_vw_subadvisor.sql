select
    ci.clientname                             as clientname
  , content:fkalclient::integer               as fkalclient
  , content:pksubadvisor::integer             as pksubadvisor
  , content:fkpersonal::integer               as fkpersonal
  , content:fkpayee::integer                  as fkpayee
  , content:isactive::boolean::int            as isactive
  , content:sacode::varchar(150)              as sacode
  , content:description::varchar(65535)       as description
  , content:masteracctcode::varchar(60)       as masteracctcode
  , content:fksubadvisorglobal::integer       as fksubadvisorglobal
  , content:gettargetallocemail::boolean::int as gettargetallocemail
  , content:targetallocemails::varchar(65535) as targetallocemails
  , content:eclipsefirmid::integer            as eclipsefirmid
  , content:subadvisorcreateddate::date       as subadvisorcreateddate
  , content:subadvisorcreatedby::varchar(60)  as subadvisorcreatedby
  , content:editeddate::date                  as editeddate
  , content:editedby::varchar(60)             as editedby
  , content:createddate::timestamp            as createddate
  , a.effective_at::date                      as effective_date
  , a._pk::varchar(200)                       as _pk
  , a._client::int                            as _client
  , a._extracted_at                           as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_subadvisor'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'vw_subadvisor') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
