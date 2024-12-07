select
    ci.clientname                                           as clientname
    , ci.system_name                                        as system_name
    , ci.system_instance                                    as system_instance
    , ci.system_key                                         as system_key
    , ci.firm_source                                        as firm_source
    , a.content:fkalclient::integer                         as fkalclient
    , a.content:fkgroupentityenum::integer                  as fkgroupentityenum
    , a.content:daterangename::varchar(60)                  as daterangename
    , a.content:fkgroupentity::integer                      as fkgroupentity
    , a.content:calcgrossoffees::boolean::int               as calcgrossoffees
    , a.content:annualizedperformance::double               as annualizedperformance
    , a.content:unnanualizedperformance::double             as unnanualizedperformance
    , a.content:twrunannualizedfactor::double               as twrunannualizedfactor
    , a.content:daysinperiod::integer                       as daysinperiod
    , a.content:groupname::varchar(600)                     as groupname
    , a.content:groupinceptiondate::timestamp               as groupinceptiondate
    , a.content:groupclosedate::timestamp                   as groupclosedate
    , a.content:groupcalcgrossoffees::boolean::int          as groupcalcgrossoffees
    , a.content:groupincludeaccruedint::boolean::int        as groupincludeaccruedint
    , a.content:groupmarketvalue::double                    as groupmarketvalue
    , a.content:allowfirstdayperformance::boolean::int      as allowfirstdayperformance
    , a.content:allowintradayperformance::boolean::int      as allowintradayperformance
    , a.content:startdate::timestamp                        as startdate
    , a.content:enddate::timestamp                          as enddate
    , a.content:datamustexistonrangestartdate::boolean::int as datamustexistonrangestartdate
    , a.content:datamustexistonrangeenddate::boolean::int   as datamustexistonrangeenddate
    , a.content:lastcompleteddate::timestamp                as lastcompleteddate
    , a.content:createddate::timestamp                      as createddate
    , a.effective_at::date                                  as effective_date
    , a._pk::varchar(200)                                   as _pk

    , a._extracted_at::timestamp_ntz                        as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_savedperformance'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                       as _is_full
    , a._created_at::timestamp_ntz                          as _created_at
    , a._source_file                                        as _source_file
    , a._checksum                                           as _checksum
from {{ source('orion', 'vw_savedperformance') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
