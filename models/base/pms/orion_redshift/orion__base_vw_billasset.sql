select
    ci.clientname                            as clientname
  , content:fkalclient::integer              as fkalclient
  , content:pkbillasset::integer             as pkbillasset
  , content:fkasset::integer                 as fkasset
  , content:fkbillaccount::integer           as fkbillaccount
  , content:isfeeexcluded::boolean::int      as isfeeexcluded
  , content:ispayingfee::boolean::int        as ispayingfee
  , content:timestampbillasset::varchar(200) as timestampbillasset
  , content:editeddate::date                 as editeddate
  , content:editedby::varchar(150)           as editedby
  , content:billassetcreateddate::date       as billassetcreateddate
  , content:billassetcreatedby::varchar(150) as billassetcreatedby
  , content:excludeamount::double precision  as excludeamount
  , content:excludeamounttype::integer       as excludeamounttype
  , content:excludepercentof::integer        as excludepercentof
  , content:excludestartdate::date           as excludestartdate
  , content:excludeenddate::date             as excludeenddate
  , content:createddate::timestamp           as createddate
  , a.effective_at::date                     as effective_date
  , a._pk::varchar(200)                      as _pk
  , a._client::int                           as _client
  , a._extracted_at                          as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_billasset'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                          as _is_full
  , a._created_at                            as _created_at
  , a._source_file                           as _source_file
  , a._checksum                              as _checksum
from {{ source('orion', 'stg_vw_billasset') }} a
join {{ ref('orion__base_vw_clientinfo') }}    ci
     on a._client::int = ci.pkalclient
