select
    ci.clientname                                     as clientname
    , ci.system_name                                  as system_name
    , ci.system_instance                              as system_instance
    , ci.system_key                                   as system_key
    , ci.firm_source                                  as firm_source
    , a.content:fkalclient::integer                   as fkalclient
    , a.content:pkbillmasterschedule::integer         as pkbillmasterschedule
    , a.content:itemkey::varchar(20)                  as itemkey
    , a.content:sname::varchar(60)                    as sname
    , a.content:ispoints::boolean::int                as ispoints
    , a.content:description::varchar(250)             as description
    , a.content:isdefault::boolean::int               as isdefault
    , a.content:fkbillentity::integer                 as fkbillentity
    , a.content:fkbillschedule::integer               as fkbillschedule
    , a.content:isremainder::boolean::int             as isremainder
    , a.content:bmscreateddate::date                  as bmscreateddate
    , a.content:bmscreatedby::varchar(60)             as bmscreatedby
    , a.content:editeddate::date                      as editeddate
    , a.content:editedby::varchar(60)                 as editedby
    , a.content:timestampmasterschedule::varchar(200) as timestampmasterschedule
    , a.content:createddate::timestamp                as createddate
    , a.effective_at::date                            as effective_date
    , a._pk::varchar(200)                             as _pk

    , a._extracted_at::timestamp_ntz                  as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billmasterschedule'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                 as _is_full
    , a._created_at::timestamp_ntz                    as _created_at
    , a._source_file                                  as _source_file
    , a._checksum                                     as _checksum
from {{ source('orion', 'vw_billmasterschedule') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
