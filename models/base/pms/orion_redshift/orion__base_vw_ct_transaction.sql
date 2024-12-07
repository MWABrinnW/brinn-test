select
    ci.clientname                              as clientname
    , ci.system_name                           as system_name
    , ci.system_instance                       as system_instance
    , ci.system_key                            as system_key
    , ci.firm_source                           as firm_source

    , a.content:changetimestamp::timestamp_ntz as changetimestamp
    , a.content:pktransaction::int             as pktransaction
    , a.content:fkalclient::int                as fkalclient

    , a._extracted_at::timestamp_ntz           as _extracted_at
    , a._is_full::int                          as _is_full
    , a._created_at::timestamp_ntz             as _created_at
    , a._source_file                           as _source_file
    , a._checksum                              as _checksum
from {{ source('orion', 'vw_ct_transaction') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
