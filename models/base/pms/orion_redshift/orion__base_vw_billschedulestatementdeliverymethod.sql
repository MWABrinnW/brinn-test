select
    ci.clientname                                          as clientname
  , content:fkalclient::integer                            as fkalclient
  , content:pkbillschedulestatementdeliverymethod::integer as pkbillschedulestatementdeliverymethod
  , content:fkbillschedule::integer                        as fkbillschedule
  , content:fkdeliverymethodaccounttype::integer           as fkdeliverymethodaccounttype
  , content:deliverymethodaccounttypename::varchar(50)     as deliverymethodaccounttypename
  , content:bboth::boolean::int                            as bboth
  , content:mail::boolean::int                             as mail
  , content:email::boolean::int                            as email
  , content:nostatement::boolean::int                      as nostatement
  , content:websiteonly::boolean::int                      as websiteonly
  , content:createddate::timestamp                         as createddate
  , a.effective_at::date                                   as effective_date
  , a._pk::varchar(200)                                    as _pk
  , a._client::int                                         as _client
  , a._extracted_at                                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_billschedulestatementdeliverymethod'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                        as _is_full
  , a._created_at                                          as _created_at
  , a._source_file                                         as _source_file
  , a._checksum                                            as _checksum
from {{ source('orion', 'stg_vw_billschedulestatementdeliverymethod') }} a
join {{ ref('orion__base_vw_clientinfo') }}                              ci
     on a._client::int = ci.pkalclient
