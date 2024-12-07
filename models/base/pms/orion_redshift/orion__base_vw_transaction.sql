select
    ci.clientname                                                   as clientname
    , ci.system_name                                                as system_name
    , ci.system_instance                                            as system_instance
    , ci.system_key                                                 as system_key
    , ci.firm_source                                                as firm_source
    , a.content:fkalclient::integer                                 as fkalclient
    , a.content:pktransaction::integer                              as pktransaction
    , a.content:fkasset::integer                                    as fkasset
    , a.content:transdate::date                                     as transdate
    , a.content:fktranstype::integer                                as fktranstype
    , a.content:transtype::varchar(60)                              as transtype
    , a.content:transtypedesc::varchar(300)                         as transtypedesc
    , a.content:nounits::double precision                           as nounits
    , a.content:transamount::double precision                       as transamount
    , a.content:navprice::double precision                          as navprice
    , a.content:fktradestatus::integer                              as fktradestatus
    , a.content:settledate::date                                    as settledate
    , a.content:trancreateddate::date                               as trancreateddate
    , a.content:trancreatedby::varchar(500)                         as trancreatedby
    , a.content:editeddate::date                                    as editeddate
    , a.content:editedby::varchar(600)                              as editedby
    , a.content:isnmready::boolean::int                             as isnmready
    , a.content:notes::varchar(2000)                                as notes
    , a.content:swpdate::date                                       as swpdate
    , a.content:isadvancebilled::boolean::int                       as isadvancebilled
    , a.content:state::varchar(20)                                  as state
    , a.content:fkdistcode::integer                                 as fkdistcode
    , a.content:fkcontribcode::integer                              as fkcontribcode
    , a.content:traderefnum::varchar(200)                           as traderefnum
    , a.content:fktraderequest::integer                             as fktraderequest
    , a.content:tranlinkcode::varchar(250)                          as tranlinkcode
    , a.content:fkpayee::integer                                    as fkpayee
    , a.content:advisornotes::varchar(2000)                         as advisornotes
    , a.content:fktransactionsubtype::integer                       as fktransactionsubtype
    , a.content:transsubtype::varchar(40)                           as transsubtype
    , a.content:transsubtypedesc::varchar(200)                      as transsubtypedesc
    , a.content:eclipseorderid::integer                             as eclipseorderid
    , a.content:perffeebreak::boolean::int                          as perffeebreak
    , a.content:yieldtomaturity::double precision                   as yieldtomaturity
    , a.content:isoid::boolean::int                                 as isoid
    , a.content:fktraderequest_ext::integer                         as fktraderequest_ext
    , a.content:commindicator::integer                              as commindicator
    , a.content:ordertype::integer                                  as ordertype
    , a.content:marketcode::integer                                 as marketcode
    , a.content:blottercode::integer                                as blottercode
    , a.content:distindicator::integer                              as distindicator
    , a.content:spreadstraddle::integer                             as spreadstraddle
    , a.content:brokercode::varchar(500)                            as brokercode
    , a.content:includeasrmddistrib::boolean::int                   as includeasrmddistrib
    , a.content:includeasrmddistribissystemmaintained::boolean::int as includeasrmddistribissystemmaintained
    , a.content:divexdate::date                                     as divexdate
    , a.content:createddate::timestamp                              as createddate
    , a.content:transdate::date                                     as effective_date
    , a._pk::varchar(200)                                           as _pk

    , a._extracted_at::timestamp_ntz                                as _extracted_at
    , 1::int                                                        as is_head
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                               as _is_full
    , a._created_at::timestamp_ntz                                  as _created_at
    , a._source_file                                                as _source_file
    , a._checksum                                                   as _checksum
from {{ source('orion', 'vw_transaction') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
