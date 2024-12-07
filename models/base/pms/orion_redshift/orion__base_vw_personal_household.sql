select
    ci.clientname                                 as clientname
    , ci.system_name                              as system_name
    , ci.system_instance                          as system_instance
    , ci.system_key                               as system_key
    , ci.firm_source                              as firm_source
    , a.content:hh_fkalclient::integer            as hh_fkalclient
    , a.content:hh_pkclient::integer              as hh_pkclient
    , a.content:hh_fkpersonal::integer            as hh_fkpersonal
    , a.content:hh_pers_entityname::varchar(400)  as hh_pers_entityname
    , a.content:hh_pers_encssn::varchar(255)      as hh_pers_encssn
    , a.content:hh_pers_encssnkeyversion::integer as hh_pers_encssnkeyversion
    , a.effective_at::date                        as effective_date
    , a._pk::varchar(200)                         as _pk
    , a._extracted_at::timestamp_ntz              as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_personal_household'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                             as _is_full
    , a._created_at::timestamp_ntz                as _created_at
    , a._source_file                              as _source_file
    , a._checksum                                 as _checksum
from {{ source('orion', 'vw_personal_household') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:hh_fkalclient::int = ci.pkalclient
