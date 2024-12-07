select
    ci.clientname                                   as clientname
    , ci.system_name                                as system_name
    , ci.system_instance                            as system_instance
    , ci.system_key                                 as system_key
    , ci.firm_source                                as firm_source
    , a.content:fkalclient::integer                 as fkalclient
    , a.content:pkbrokerdealer::integer             as pkbrokerdealer
    , a.content:fkpersonal::integer                 as fkpersonal
    , a.content:overidecode::varchar(60)            as overidecode
    , a.content:overideperc::double precision       as overideperc
    , a.content:agentid::varchar(20)                as agentid
    , a.content:oldbd_id::integer                   as oldbd_id
    , a.content:oldbdcode::varchar(20)              as oldbdcode
    , a.content:impdate::date                       as impdate
    , a.content:editeddate::date                    as editeddate
    , a.content:editedby::varchar(150)              as editedby
    , a.content:bdcreateddate::date                 as bdcreateddate
    , a.content:bdcreatedby::varchar(150)           as bdcreatedby
    , a.content:isactive::boolean::int              as isactive
    , a.content:bdstatus::integer                   as bdstatus
    , a.content:clearingfirm::integer               as clearingfirm
    , a.content:crdnumber::varchar(60)              as crdnumber
    , a.content:howisadvregistered::integer         as howisadvregistered
    , a.content:isadvonfile::boolean::int           as isadvonfile
    , a.content:isproductionreported::boolean::int  as isproductionreported
    , a.content:frequency::integer                  as frequency
    , a.content:ismktingmaterialsent::boolean::int  as ismktingmaterialsent
    , a.content:issendingquestionaire::boolean::int as issendingquestionaire
    , a.content:transmissionmethod::integer         as transmissionmethod
    , a.content:transmissionformat::integer         as transmissionformat
    , a.content:fkria::integer                      as fkria
    , a.content:fkpayee::integer                    as fkpayee
    , a.content:fkbillpayoutschedule::integer       as fkbillpayoutschedule
    , a.content:actgledgernum::varchar(60)          as actgledgernum
    , a.content:isadvoneagree::boolean::int         as isadvoneagree
    , a.content:advonerestrictions::varchar(600)    as advonerestrictions
    , a.content:advoneagreedate::date               as advoneagreedate
    , a.content:agreedate::date                     as agreedate
    , a.content:agreerestrictions::varchar(600)     as agreerestrictions
    , a.content:replistrecvdate::date               as replistrecvdate
    , a.content:natconference::varchar(250)         as natconference
    , a.content:regconference::varchar(250)         as regconference
    , a.content:marketingnotes::varchar(600)        as marketingnotes
    , a.content:advyear::integer                    as advyear
    , a.content:clssendadvto::varchar(60)           as clssendadvto
    , a.content:reportssendto::varchar(600)         as reportssendto
    , a.content:reportsfax::varchar(20)             as reportsfax
    , a.content:reportsemail::varchar(600)          as reportsemail
    , a.content:mktmaterialsendto::varchar(600)     as mktmaterialsendto
    , a.content:mktmaterialemail::varchar(600)      as mktmaterialemail
    , a.content:mktmaterialfax::varchar(20)         as mktmaterialfax
    , a.content:bdreprestrict::varchar(200)         as bdreprestrict
    , a.content:albridgeid::integer                 as albridgeid
    , a.content:dazlid::varchar(60)                 as dazlid
    , a.content:fkbrokerdealerglobal::integer       as fkbrokerdealerglobal
    , a.content:isvalueeditlockeddown::boolean::int as isvalueeditlockeddown
    , a.content:createddate::timestamp              as createddate
    , a.effective_at::date                          as effective_date
    , a._pk::varchar(200)                           as _pk

    , a._extracted_at::timestamp_ntz                as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_brokerdealer'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                               as _is_full
    , a._created_at::timestamp_ntz                  as _created_at
    , a._source_file                                as _source_file
    , a._checksum                                   as _checksum
from {{ source('orion', 'vw_brokerdealer') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
