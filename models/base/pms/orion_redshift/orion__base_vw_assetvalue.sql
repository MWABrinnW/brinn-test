select
    ci.clientname                             as clientname
  , content:fkalclient::integer               as fkalclient
  , content:fkasset::integer                  as fkasset
  , content:asofdateint::integer              as asofdateint
  , content:asofdate::date                    as asofdate
  , content:unitbalance::double precision     as unitbalance
  , content:navprice::double precision        as navprice
  , content:calculatedvalue::double precision as calculatedvalue
  , content:createddate::timestamp            as createddate
  , content:asofdate::date                    as effective_date
  , a._pk::varchar(200)                       as _pk
  , a._client::int                            as _client
  , a._extracted_at                           as _extracted_at
  , 1::int                                    as is_head
  , {{ col_is_current(date_col='a.content:asofdate::date') }}
  , a._is_full::int                           as _is_full
  , a._created_at                             as _created_at
  , a._source_file                            as _source_file
  , a._checksum                               as _checksum
from {{ source('orion', 'vw_assetvalue') }} a
join {{ ref('orion__base_vw_clientinfo') }}     ci
     on a._client::int = ci.pkalclient
