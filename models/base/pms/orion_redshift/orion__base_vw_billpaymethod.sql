select
    ci.clientname                         as clientname
  , content:fkalclient::integer           as fkalclient
  , content:pkbillpaymethod::integer      as pkbillpaymethod
  , content:spayinstruction::varchar(30)  as spayinstruction
  , content:spaydesc::varchar(300)        as spaydesc
  , content:itemdata::integer             as itemdata
  , content:invoiceverbage::varchar(1100) as invoiceverbage
  , content:dayofmonthdue::integer        as dayofmonthdue
  , content:fktrinterface::integer        as fktrinterface
  , content:paymenttype::integer          as paymenttype
  , content:fkuploadtarget::integer       as fkuploadtarget
  , content:createddate::timestamp        as createddate
  , a.effective_at::date                  as effective_date
  , a._pk::varchar(200)                   as _pk
  , a._client::int                        as _client
  , a._extracted_at                       as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_billpaymethod'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                       as _is_full
  , a._created_at                         as _created_at
  , a._source_file                        as _source_file
  , a._checksum                           as _checksum
from {{ source('orion', 'stg_vw_billpaymethod') }} a
join {{ ref('orion__base_vw_clientinfo') }}        ci
     on a._client::int = ci.pkalclient
