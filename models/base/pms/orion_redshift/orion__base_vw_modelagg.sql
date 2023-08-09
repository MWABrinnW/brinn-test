select
    ci.clientname                                     as clientname
  , content:fkalclient::integer                       as fkalclient
  , content:fkmodelagg::integer                       as fkmodelagg
  , content:aggregationname::varchar(300)             as aggregationname
  , content:keepalways::boolean::int                  as keepalways
  , content:issystemmaintained::boolean::int          as issystemmaintained
  , content:accountnumbersuffix::varchar(25)          as accountnumbersuffix
  , content:fkentity::integer                         as fkentity
  , content:entityenum::integer                       as entityenum
  , content:include::boolean::int                     as include
  , content:fkmodelaggtype::integer                   as fkmodelaggtype
  , content:riskscore::double precision               as riskscore
  , content:advisoryworldmodel::boolean::int          as advisoryworldmodel
  , content:proposalenabled::boolean::int             as proposalenabled
  , content:hasmanagerfactsheet::boolean::int         as hasmanagerfactsheet
  , content:sortorder::integer                        as sortorder
  , content:eclipsefirmid::integer                    as eclipsefirmid
  , content:eclipsemodelid::integer                   as eclipsemodelid
  , content:minimuminvestmentamount::double precision as minimuminvestmentamount
  , content:fkbillschedule::integer                   as fkbillschedule
  , content:fkbillmasterpayoutschedule::integer       as fkbillmasterpayoutschedule
  , content:color::varchar(60)                        as color
  , content:issociallyresponsible::boolean::int       as issociallyresponsible
  , content:taxmanaged::boolean::int                  as taxmanaged
  , content:modelstrategytype::varchar(60)            as modelstrategytype
  , content:modelassettype::varchar(60)               as modelassettype
  , content:modelassetclass::varchar(60)              as modelassetclass
  , content:modelriskcategory::varchar(60)            as modelriskcategory
  , content:morningstarid::varchar(150)               as morningstarid
  , content:isastroenabled::boolean::int              as isastroenabled
  , content:morningstarproductid::integer             as morningstarproductid
  , content:fkindexblend::integer                     as fkindexblend
  , content:synctoastro::boolean::int                 as synctoastro
  , content:worstreturn::double precision             as worstreturn
  , content:averagereturn::double precision           as averagereturn
  , content:bestreturn::double precision              as bestreturn
  , content:aggcreateddate::date                      as aggcreateddate
  , content:aggcreatedby::varchar(200)                as aggcreatedby
  , content:editeddate::date                          as editeddate
  , content:editedby::varchar(200)                    as editedby
  , content:createddate::timestamp                    as createddate
  , a.effective_at::date                              as effective_date
  , a._pk::varchar(200)                               as _pk
  , a._client::int                                    as _client
  , a._extracted_at                                   as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_modelagg'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                   as _is_full
  , a._created_at                                     as _created_at
  , a._source_file                                    as _source_file
  , a._checksum                                       as _checksum
from {{ source('orion', 'vw_modelagg') }}   a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
