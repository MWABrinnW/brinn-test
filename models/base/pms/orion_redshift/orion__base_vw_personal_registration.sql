select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:reg_fkalclient::integer           as reg_fkalclient
    , a.content:reg_pkregistration::integer       as reg_pkregistration
    , a.content:reg_fkpersonal::integer           as reg_fkpersonal
    , a.content:reg_pers_entityname::varchar(255) as reg_pers_entityname
    , a.effective_at::date                        as effective_date
    , a._pk::varchar(200)                         as _pk

    , a._extracted_at::timestamp_ntz              as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_personal_registration'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                             as _is_full
    , a._created_at::timestamp_ntz                as _created_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_personal_registration') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:reg_fkalclient::int = ci.pkalclient
