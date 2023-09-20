select
    ci.clientname                                               as clientname
  , content:fkalclient::integer                                 as fkalclient
  , content:pktransaction::integer                              as pktransaction
  , content:fkasset::integer                                    as fkasset
  , content:transdate::date                                     as transdate
  , content:fktranstype::integer                                as fktranstype
  , content:transtype::varchar(60)                              as transtype
  , content:transtypedesc::varchar(300)                         as transtypedesc
  , content:nounits::double precision                           as nounits
  , content:transamount::double precision                       as transamount
  , content:navprice::double precision                          as navprice
  , content:fktradestatus::integer                              as fktradestatus
  , content:settledate::date                                    as settledate
  , content:trancreateddate::date                               as trancreateddate
  , content:trancreatedby::varchar(500)                         as trancreatedby
  , content:editeddate::date                                    as editeddate
  , content:editedby::varchar(600)                              as editedby
  , content:isnmready::boolean::int                             as isnmready
  , content:notes::varchar(2000)                                as notes
  , content:swpdate::date                                       as swpdate
  , content:isadvancebilled::boolean::int                       as isadvancebilled
  , content:state::varchar(20)                                  as state
  , content:fkdistcode::integer                                 as fkdistcode
  , content:fkcontribcode::integer                              as fkcontribcode
  , content:traderefnum::varchar(200)                           as traderefnum
  , content:fktraderequest::integer                             as fktraderequest
  , content:tranlinkcode::varchar(250)                          as tranlinkcode
  , content:fkpayee::integer                                    as fkpayee
  , content:advisornotes::varchar(2000)                         as advisornotes
  , content:fktransactionsubtype::integer                       as fktransactionsubtype
  , content:transsubtype::varchar(40)                           as transsubtype
  , content:transsubtypedesc::varchar(200)                      as transsubtypedesc
  , content:eclipseorderid::integer                             as eclipseorderid
  , content:perffeebreak::boolean::int                          as perffeebreak
  , content:yieldtomaturity::double precision                   as yieldtomaturity
  , content:isoid::boolean::int                                 as isoid
  , content:fktraderequest_ext::integer                         as fktraderequest_ext
  , content:commindicator::integer                              as commindicator
  , content:ordertype::integer                                  as ordertype
  , content:marketcode::integer                                 as marketcode
  , content:blottercode::integer                                as blottercode
  , content:distindicator::integer                              as distindicator
  , content:spreadstraddle::integer                             as spreadstraddle
  , content:brokercode::varchar(500)                            as brokercode
  , content:includeasrmddistrib::boolean::int                   as includeasrmddistrib
  , content:includeasrmddistribissystemmaintained::boolean::int as includeasrmddistribissystemmaintained
  , content:divexdate::date                                     as divexdate
  , content:createddate::timestamp                              as createddate
  , content:transdate::date                                     as effective_date
  , a._pk::varchar(200)                                         as _pk
  , a._client::int                                              as _client
  , a._extracted_at                                             as _extracted_at
  , 1::int                                                      as is_head
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                             as _is_full
  , a._created_at                                               as _created_at
  , a._source_file                                              as _source_file
  , a._checksum                                                 as _checksum
from {{ source('orion', 'vw_transaction') }} a
join {{ ref('orion__base_vw_clientinfo') }}      ci
     on a._client::int = ci.pkalclient
