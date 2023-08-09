select
    ci.clientname                         as clientname
  , content:fkalclient::integer           as fkalclient
  , content:pkbill::integer               as pkbill
  , content:fkbillclient::integer         as fkbillclient
  , content:fkbilltransmitmethod::integer as fkbilltransmitmethod
  , content:fkblob::integer               as fkblob
  , content:dtcalcdate::date              as dtcalcdate
  , content:billediteddate::date          as billediteddate
  , content:billeditedby::varchar(50)     as billeditedby
  , content:billcreateddate::date         as billcreateddate
  , content:billcreatedby::varchar(50)    as billcreatedby
  , content:isvalid::integer              as isvalid
  , content:oldinvoiceno::integer         as oldinvoiceno
  , content:billtype::integer             as billtype
  , content:fkbillinstance::integer       as fkbillinstance
  , content:fkclientstamp::integer        as fkclientstamp
  , content:fkbillaccountitem::integer    as fkbillaccountitem
  , content:createddate::timestamp        as createddate
  , a.effective_at::date                  as effective_date
  , a._pk::varchar(200)                   as _pk
  , a._client::int                        as _client
  , a._extracted_at                       as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_bill'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                       as _is_full
  , a._created_at                         as _created_at
  , a._source_file                        as _source_file
  , a._checksum                           as _checksum
from {{ source('orion', 'stg_vw_bill') }}   a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
