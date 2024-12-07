select
    ci.clientname                                          as clientname
    , ci.system_name                                       as system_name
    , ci.system_instance                                   as system_instance
    , ci.system_key                                        as system_key
    , ci.firm_source                                       as firm_source
    , a.content:fkalclient::integer                        as fkalclient
    , a.content:pkbillschedule::integer                    as pkbillschedule
    , a.content:itemkey::varchar(20)                       as itemkey
    , a.content:sschedule::varchar(60)                     as sschedule
    , a.content:sschedtype::varchar(20)                    as sschedtype
    , a.content:ischedenum::integer                        as ischedenum
    , a.content:basis::integer                             as basis
    , a.content:basisname::varchar(50)                     as basisname
    , a.content:fkbillentity::integer                      as fkbillentity
    , a.content:description::varchar(250)                  as description
    , a.content:minfee::double precision                   as minfee
    , a.content:howbilled::integer                         as howbilled
    , a.content:howbilledname::varchar(50)                 as howbilledname
    , a.content:schedulecode::varchar(20)                  as schedulecode
    , a.content:showinfeecalculator::boolean::int          as showinfeecalculator
    , a.content:minfeeacctvaluethreshold::double precision as minfeeacctvaluethreshold
    , a.content:fkbillscheduleglobal::integer              as fkbillscheduleglobal
    , a.content:usestatementdeliverymethod::boolean::int   as usestatementdeliverymethod
    , a.content:ispayoutcreditoffset::boolean::int         as ispayoutcreditoffset
    , a.content:linearbreakpointmaximums::boolean::int     as linearbreakpointmaximums
    , a.content:aggregatebyhousehold::boolean::int         as aggregatebyhousehold
    , a.content:billschedulecreateddate::date              as billschedulecreateddate
    , a.content:billschedulecreatedby::varchar(120)        as billschedulecreatedby
    , a.content:editeddate::date                           as editeddate
    , a.content:editedby::varchar(120)                     as editedby
    , a.content:entityenum::integer                        as entityenum
    , a.content:fkentity::integer                          as fkentity
    , a.content:isactive::boolean::int                     as isactive
    , a.content:cminamt::double precision                  as cminamt
    , a.content:cmaxamt::double precision                  as cmaxamt
    , a.content:drate::double precision                    as drate
    , a.content:points::double precision                   as points
    , a.content:flatfee::double precision                  as flatfee
    , a.content:reducedrate::double precision              as reducedrate
    , a.content:reducedrateminamount::double precision     as reducedrateminamount
    , a.content:fkbillscheduledetailglobal::integer        as fkbillscheduledetailglobal
    , a.content:fkmodel::integer                           as fkmodel
    , a.content:fkbrokerdealer::integer                    as fkbrokerdealer
    , a.content:createddate::timestamp                     as createddate
    , a.effective_at::date                                 as effective_date
    , a._pk::varchar(200)                                  as _pk

    , a._extracted_at::timestamp_ntz                       as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_billschedule'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                      as _is_full
    , a._created_at::timestamp_ntz                         as _created_at
    , a._source_file                                       as _source_file
    , a._checksum                                          as _checksum
from {{ source('orion', 'vw_billschedule') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
