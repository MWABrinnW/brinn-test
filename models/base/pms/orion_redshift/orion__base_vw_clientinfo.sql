select
    a.content:pkalclient::int                      as pkalclient
    , a.content:clientname::varchar(200)           as clientname
    , 'orion'                                      as system_name
    , {{ orion_instance('a.content:pkalclient::int') }}
    , concat(system_name , '__' , system_instance) as system_key
    , {{ orion_firm_source('a.content:pkalclient::int') }}
    , a.effective_at::date                         as effective_date
    , a._pk::varchar(200)                          as _pk
    , a._extracted_at::timestamp_ntz               as _extracted_at

    , a._is_full::int                              as _is_full
    , a._created_at::timestamp_ntz                 as _created_at
    , a._source_file                               as _source_file
    , a._checksum                                  as _checksum
from {{ source('orion', 'vw_clientinfo') }} as a
