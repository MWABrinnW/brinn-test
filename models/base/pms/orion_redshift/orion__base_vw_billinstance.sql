select
    ci.clientname                                 as clientname
  , content:fkalclient::integer                   as fkalclient
  , content:pkbillinstance::integer               as pkbillinstance
  , content:binstancecreateddate::timestamp       as binstancecreateddate
  , content:binstancecreatedby::varchar(40)       as binstancecreatedby
  , content:status::varchar(200)                  as status
  , content:perccomplete::integer                 as perccomplete
  , content:billtype::integer                     as billtype
  , content:fkblobpayablereport::integer          as fkblobpayablereport
  , content:ismockbill::boolean::int              as ismockbill
  , content:runfor::integer                       as runfor
  , content:runforkeylist::varchar(65535)         as runforkeylist
  , content:asofdate::date                        as asofdate
  , content:billfrequency::integer                as billfrequency
  , content:billstyle::integer                    as billstyle
  , content:enddateoverride::date                 as enddateoverride
  , content:valuedateoverride::date               as valuedateoverride
  , content:hangfirejobid::varchar(65535)         as hangfirejobid
  , content:hangfirejobtype::integer              as hangfirejobtype
  , content:entityoptions::varchar(65535)         as entityoptions
  , content:statusvalue::integer                  as statusvalue
  , content:correlationid::varchar(60)            as correlationid
  , content:fktrinstancefee::integer              as fktrinstancefee
  , content:nickname::varchar(300)                as nickname
  , content:includecashflows::boolean::int        as includecashflows
  , content:allowduplicatemockbills::boolean::int as allowduplicatemockbills
  , content:isfinalbill::boolean::int             as isfinalbill
  , content:excludeadjustments::boolean::int      as excludeadjustments
  , content:runforaccounts::integer               as runforaccounts
  , content:createddate::timestamp                as createddate
  , a.effective_at::date                          as effective_date
  , a._pk::varchar(200)                           as _pk
  , a._client::int                                as _client
  , a._extracted_at                               as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_billinstance'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                               as _is_full
  , a._created_at                                 as _created_at
  , a._source_file                                as _source_file
  , a._checksum                                   as _checksum
from {{ source('orion', 'vw_billinstance') }} a
join {{ ref('orion__base_vw_clientinfo') }}       ci
     on a._client::int = ci.pkalclient
