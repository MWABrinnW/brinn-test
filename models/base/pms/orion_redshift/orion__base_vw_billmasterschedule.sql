select
    ci.clientname                                 as clientname
  , content:fkalclient::integer                   as fkalclient
  , content:pkbillmasterschedule::integer         as pkbillmasterschedule
  , content:itemkey::varchar(20)                  as itemkey
  , content:sname::varchar(60)                    as sname
  , content:ispoints::boolean::int                as ispoints
  , content:description::varchar(250)             as description
  , content:isdefault::boolean::int               as isdefault
  , content:fkbillentity::integer                 as fkbillentity
  , content:fkbillschedule::integer               as fkbillschedule
  , content:isremainder::boolean::int             as isremainder
  , content:bmscreateddate::date           as bmscreateddate
  , content:bmscreatedby::varchar(60)                    as bmscreatedby
  , content:editeddate::date               as editeddate
  , content:editedby::varchar(60)                        as editedby
  , content:timestampmasterschedule::varchar(200) as timestampmasterschedule
  , content:createddate::timestamp                as createddate
  , a.effective_at::date                          as effective_date
  , a._pk::varchar(200)                           as _pk
  , a._client::int                                as _client
  , a._extracted_at                               as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_billmasterschedule'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                               as _is_full
  , a._created_at                                 as _created_at
  , a._source_file                                as _source_file
  , a._checksum                                   as _checksum
from {{ source('orion', 'vw_billmasterschedule') }} a
join {{ ref('orion__base_vw_clientinfo') }}             ci
     on a._client::int = ci.pkalclient
