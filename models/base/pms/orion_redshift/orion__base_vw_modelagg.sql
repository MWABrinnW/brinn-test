select
    ci.clientname                                         as clientname
    , ci.system_name                                      as system_name
    , ci.system_instance                                  as system_instance
    , ci.system_key                                       as system_key
    , ci.firm_source                                      as firm_source
    , a.content:fkalclient::integer                       as fkalclient
    , a.content:fkmodelagg::integer                       as fkmodelagg
    , a.content:aggregationname::varchar(300)             as aggregationname
    , a.content:keepalways::boolean::int                  as keepalways
    , a.content:issystemmaintained::boolean::int          as issystemmaintained
    , a.content:accountnumbersuffix::varchar(25)          as accountnumbersuffix
    , a.content:fkentity::integer                         as fkentity
    , a.content:entityenum::integer                       as entityenum
    , a.content:include::boolean::int                     as include
    , a.content:fkmodelaggtype::integer                   as fkmodelaggtype
    , a.content:riskscore::double precision               as riskscore
    , a.content:advisoryworldmodel::boolean::int          as advisoryworldmodel
    , a.content:proposalenabled::boolean::int             as proposalenabled
    , a.content:hasmanagerfactsheet::boolean::int         as hasmanagerfactsheet
    , a.content:sortorder::integer                        as sortorder
    , a.content:eclipsefirmid::integer                    as eclipsefirmid
    , a.content:eclipsemodelid::integer                   as eclipsemodelid
    , a.content:minimuminvestmentamount::double precision as minimuminvestmentamount
    , a.content:fkbillschedule::integer                   as fkbillschedule
    , a.content:fkbillmasterpayoutschedule::integer       as fkbillmasterpayoutschedule
    , a.content:color::varchar(60)                        as color
    , a.content:issociallyresponsible::boolean::int       as issociallyresponsible
    , a.content:taxmanaged::boolean::int                  as taxmanaged
    , a.content:modelstrategytype::varchar(60)            as modelstrategytype
    , a.content:modelassettype::varchar(60)               as modelassettype
    , a.content:modelassetclass::varchar(60)              as modelassetclass
    , a.content:modelriskcategory::varchar(60)            as modelriskcategory
    , a.content:morningstarid::varchar(150)               as morningstarid
    , a.content:isastroenabled::boolean::int              as isastroenabled
    , a.content:morningstarproductid::integer             as morningstarproductid
    , a.content:fkindexblend::integer                     as fkindexblend
    , a.content:synctoastro::boolean::int                 as synctoastro
    , a.content:worstreturn::double precision             as worstreturn
    , a.content:averagereturn::double precision           as averagereturn
    , a.content:bestreturn::double precision              as bestreturn
    , a.content:aggcreateddate::date                      as aggcreateddate
    , a.content:aggcreatedby::varchar(200)                as aggcreatedby
    , a.content:editeddate::date                          as editeddate
    , a.content:editedby::varchar(200)                    as editedby
    , a.content:createddate::timestamp                    as createddate
    , a.effective_at::date                                as effective_date
    , a._pk::varchar(200)                                 as _pk

    , a._extracted_at::timestamp_ntz                      as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_modelagg'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                     as _is_full
    , a._created_at::timestamp_ntz                        as _created_at
    , a._source_file                                      as _source_file
    , a._checksum                                         as _checksum
from {{ source('orion', 'vw_modelagg') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
