select
    ci.clientname                                       as clientname
    , ci.system_name                                    as system_name
    , ci.system_instance                                as system_instance
    , ci.system_key                                     as system_key
    , ci.firm_source                                    as firm_source
    , a.content:fkalclient::integer                     as fkalclient
    , a.content:pkregistrationtype::integer             as pkregistrationtype
    , a.content:sregcode::varchar(60)                   as sregcode
    , a.content:sregdesc::varchar(255)                  as sregdesc
    , a.content:isqual::boolean::int                    as isqual
    , a.content:isira::boolean::int                     as isira
    , a.content:is403b::boolean::int                    as is403b
    , a.content:plantype::varchar(10)                   as plantype
    , a.content:isdefault::boolean::int                 as isdefault
    , a.content:externalcode::varchar(10)               as externalcode
    , a.content:socialcode::varchar(3)                  as socialcode
    , a.content:commoncode::varchar(10)                 as commoncode
    , a.content:category::integer                       as category
    , a.content:bentypes::varchar(200)                  as bentypes
    , a.content:isbira::boolean::int                    as isbira
    , a.content:includeinrmd::boolean::int              as includeinrmd
    , a.content:excludefromrmdaggregation::boolean::int as excludefromrmdaggregation
    , a.content:proposalcode::varchar(20)               as proposalcode
    , a.content:taxtype::integer                        as taxtype
    , a.content:createddate::timestamp                  as createddate
    , a.effective_at::date                              as effective_date
    , a._pk::varchar(200)                               as _pk

    , a._extracted_at::timestamp_ntz                    as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_registrationtype'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                   as _is_full
    , a._created_at::timestamp_ntz                      as _created_at
    , a._source_file                                    as _source_file
    , a._checksum                                       as _checksum
from {{ source('orion', 'vw_registrationtype') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
