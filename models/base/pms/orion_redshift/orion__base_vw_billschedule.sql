select
    ci.clientname                                      as clientname
  , content:fkalclient::integer                        as fkalclient
  , content:pkbillschedule::integer                    as pkbillschedule
  , content:itemkey::varchar(20)                       as itemkey
  , content:sschedule::varchar(60)                     as sschedule
  , content:sschedtype::varchar(20)                    as sschedtype
  , content:ischedenum::integer                        as ischedenum
  , content:basis::integer                             as basis
  , content:basisname::varchar(50)                     as basisname
  , content:fkbillentity::integer                      as fkbillentity
  , content:description::varchar(250)                  as description
  , content:minfee::double precision                   as minfee
  , content:howbilled::integer                         as howbilled
  , content:howbilledname::varchar(50)                 as howbilledname
  , content:schedulecode::varchar(20)                  as schedulecode
  , content:showinfeecalculator::boolean::int          as showinfeecalculator
  , content:minfeeacctvaluethreshold::double precision as minfeeacctvaluethreshold
  , content:fkbillscheduleglobal::integer              as fkbillscheduleglobal
  , content:usestatementdeliverymethod::boolean::int   as usestatementdeliverymethod
  , content:ispayoutcreditoffset::boolean::int         as ispayoutcreditoffset
  , content:linearbreakpointmaximums::boolean::int     as linearbreakpointmaximums
  , content:aggregatebyhousehold::boolean::int         as aggregatebyhousehold
  , content:billschedulecreateddate::date              as billschedulecreateddate
  , content:billschedulecreatedby::varchar(120)        as billschedulecreatedby
  , content:editeddate::date                           as editeddate
  , content:editedby::varchar(120)                     as editedby
  , content:entityenum::integer                        as entityenum
  , content:fkentity::integer                          as fkentity
  , content:isactive::boolean::int                     as isactive
  , content:cminamt::double precision                  as cminamt
  , content:cmaxamt::double precision                  as cmaxamt
  , content:drate::double precision                    as drate
  , content:points::double precision                   as points
  , content:flatfee::double precision                  as flatfee
  , content:reducedrate::double precision              as reducedrate
  , content:reducedrateminamount::double precision     as reducedrateminamount
  , content:fkbillscheduledetailglobal::integer        as fkbillscheduledetailglobal
  , content:fkmodel::integer                           as fkmodel
  , content:fkbrokerdealer::integer                    as fkbrokerdealer
  , content:createddate::timestamp                     as createddate
  , a.effective_at::date                               as effective_date
  , a._pk::varchar(200)                                as _pk
  , a._client::int                                     as _client
  , a._extracted_at                                    as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_billschedule'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                    as _is_full
  , a._created_at                                      as _created_at
  , a._source_file                                     as _source_file
  , a._checksum                                        as _checksum
from {{ source('orion', 'stg_vw_billschedule') }} a
join {{ ref('orion__base_vw_clientinfo') }}       ci
     on a._client::int = ci.pkalclient
