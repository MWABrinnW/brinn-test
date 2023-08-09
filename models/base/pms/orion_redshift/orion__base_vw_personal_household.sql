select
    ci.clientname                             as clientname
  , content:hh_fkalclient::integer            as fkalclient
  , content:hh_pkclient::integer              as hh_pkclient
  , content:hh_fkpersonal::integer            as hh_fkpersonal
  , content:hh_pers_entityname::varchar(400)  as hh_pers_entityname
  , content:hh_pers_encssn::varchar(255)      as hh_pers_encssn
  , content:hh_pers_encssnkeyversion::integer as hh_pers_encssnkeyversion
  , a.effective_at::date                      as effective_date
  , a._pk::varchar(200)                       as _pk
  , content:hh_fkalclient::integer            as _client
  , a._extracted_at                           as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_personal_household'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'stg_vw_personal_household') }} a
join {{ ref('orion__base_vw_clientinfo') }}             ci
     on content:hh_fkalclient::int = ci.pkalclient
