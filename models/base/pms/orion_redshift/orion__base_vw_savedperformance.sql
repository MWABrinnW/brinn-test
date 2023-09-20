select
    ci.clientname                                       as clientname
  , content:fkalclient::integer                         as fkalclient
  , content:fkgroupentityenum::integer                  as fkgroupentityenum
  , content:daterangename::varchar(60)                  as daterangename
  , content:fkgroupentity::integer                      as fkgroupentity
  , content:calcgrossoffees::boolean::int               as calcgrossoffees
  , content:annualizedperformance::double               as annualizedperformance
  , content:unnanualizedperformance::double             as unnanualizedperformance
  , content:twrunannualizedfactor::double               as twrunannualizedfactor
  , content:daysinperiod::integer                       as daysinperiod
  , content:groupname::varchar(600)                     as groupname
  , content:groupinceptiondate::timestamp               as groupinceptiondate
  , content:groupclosedate::timestamp                   as groupclosedate
  , content:groupcalcgrossoffees::boolean::int          as groupcalcgrossoffees
  , content:groupincludeaccruedint::boolean::int        as groupincludeaccruedint
  , content:groupmarketvalue::double                    as groupmarketvalue
  , content:allowfirstdayperformance::boolean::int      as allowfirstdayperformance
  , content:allowintradayperformance::boolean::int      as allowintradayperformance
  , content:startdate::timestamp                        as startdate
  , content:enddate::timestamp                          as enddate
  , content:datamustexistonrangestartdate::boolean::int as datamustexistonrangestartdate
  , content:datamustexistonrangeenddate::boolean::int   as datamustexistonrangeenddate
  , content:lastcompleteddate::timestamp                as lastcompleteddate
  , content:createddate::timestamp                      as createddate
  , a.effective_at::date                                as effective_date
  , a._pk::varchar(200)                                 as _pk
  , a._client::int                                      as _client
  , a._extracted_at                                     as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_savedperformance'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                     as _is_full
  , a._created_at                                       as _created_at
  , a._source_file                                      as _source_file
  , a._checksum                                         as _checksum
from {{ source('orion', 'vw_savedperformance') }} a
join {{ ref('orion__base_vw_clientinfo') }}           ci
     on a._client::int = ci.pkalclient
