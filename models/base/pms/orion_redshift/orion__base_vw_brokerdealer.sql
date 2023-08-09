select
    ci.clientname                               as clientname
  , content:fkalclient::integer                 as fkalclient
  , content:pkbrokerdealer::integer             as pkbrokerdealer
  , content:fkpersonal::integer                 as fkpersonal
  , content:overidecode::varchar(60)            as overidecode
  , content:overideperc::double precision       as overideperc
  , content:agentid::varchar(20)                as agentid
  , content:oldbd_id::integer                   as oldbd_id
  , content:oldbdcode::varchar(20)              as oldbdcode
  , content:impdate::date                       as impdate
  , content:editeddate::date                    as editeddate
  , content:editedby::varchar(150)              as editedby
  , content:bdcreateddate::date                 as bdcreateddate
  , content:bdcreatedby::varchar(150)           as bdcreatedby
  , content:isactive::boolean::int              as isactive
  , content:bdstatus::integer                   as bdstatus
  , content:clearingfirm::integer               as clearingfirm
  , content:crdnumber::varchar(60)              as crdnumber
  , content:howisadvregistered::integer         as howisadvregistered
  , content:isadvonfile::boolean::int           as isadvonfile
  , content:isproductionreported::boolean::int  as isproductionreported
  , content:frequency::integer                  as frequency
  , content:ismktingmaterialsent::boolean::int  as ismktingmaterialsent
  , content:issendingquestionaire::boolean::int as issendingquestionaire
  , content:transmissionmethod::integer         as transmissionmethod
  , content:transmissionformat::integer         as transmissionformat
  , content:fkria::integer                      as fkria
  , content:fkpayee::integer                    as fkpayee
  , content:fkbillpayoutschedule::integer       as fkbillpayoutschedule
  , content:actgledgernum::varchar(60)          as actgledgernum
  , content:isadvoneagree::boolean::int         as isadvoneagree
  , content:advonerestrictions::varchar(600)    as advonerestrictions
  , content:advoneagreedate::date               as advoneagreedate
  , content:agreedate::date                     as agreedate
  , content:agreerestrictions::varchar(600)     as agreerestrictions
  , content:replistrecvdate::date               as replistrecvdate
  , content:natconference::varchar(250)         as natconference
  , content:regconference::varchar(250)         as regconference
  , content:marketingnotes::varchar(600)        as marketingnotes
  , content:advyear::integer                    as advyear
  , content:clssendadvto::varchar(60)           as clssendadvto
  , content:reportssendto::varchar(600)         as reportssendto
  , content:reportsfax::varchar(20)             as reportsfax
  , content:reportsemail::varchar(600)          as reportsemail
  , content:mktmaterialsendto::varchar(600)     as mktmaterialsendto
  , content:mktmaterialemail::varchar(600)      as mktmaterialemail
  , content:mktmaterialfax::varchar(20)         as mktmaterialfax
  , content:bdreprestrict::varchar(200)         as bdreprestrict
  , content:albridgeid::integer                 as albridgeid
  , content:dazlid::varchar(60)                 as dazlid
  , content:fkbrokerdealerglobal::integer       as fkbrokerdealerglobal
  , content:isvalueeditlockeddown::boolean::int as isvalueeditlockeddown
  , content:createddate::timestamp              as createddate
  , a.effective_at::date                        as effective_date
  , a._pk::varchar(200)                         as _pk
  , a._client::int                              as _client
  , a._extracted_at                             as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_brokerdealer'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                             as _is_full
  , a._created_at                               as _created_at
  , a._source_file                              as _source_file
  , a._checksum                                 as _checksum
from {{ source('orion', 'stg_vw_brokerdealer') }} a
join {{ ref('orion__base_vw_clientinfo') }}       ci
     on a._client::int = ci.pkalclient
