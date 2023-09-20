select
    ci.clientname                  as clientname
  , content:alclientid::integer    as fkalclient
  , content:pkuserlogin::integer   as pkuserlogin
  , content:fkuser::integer        as fkuser
  , content:logindate::timestamp   as logindate
  , content:failed::boolean::int   as failed
  , content:failtype::integer      as failtype
  , content:clientip::varchar(50)  as clientip
  , content:userid::varchar(250)   as userid
  , content:createddate::timestamp as createddate
  , a.effective_at::date           as effective_date
  , a._pk::varchar(200)            as _pk
  , a._client::int                 as _client
  , a._extracted_at                as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_userlogin'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                as _is_full
  , a._created_at                  as _created_at
  , a._source_file                 as _source_file
  , a._checksum                    as _checksum
from {{ source('orion', 'vw_userlogin') }} a
join {{ ref('orion__base_vw_clientinfo') }}    ci
     on a._client::int = ci.pkalclient
