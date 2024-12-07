select
    ci.clientname                                         as clientname
    , ci.system_name                                      as system_name
    , ci.system_instance                                  as system_instance
    , ci.system_key                                       as system_key
    , ci.firm_source                                      as firm_source
    , a.content:fkalclient::integer                       as fkalclient
    , a.content:pkcustodian::integer                      as pkcustodian
    , a.content:fkpersonal::integer                       as fkpersonal
    , a.content:name::varchar(50)                         as name
    , a.content:code::varchar(60)                         as code
    , a.content:sweeplevel::integer                       as sweeplevel
    , a.content:isdirect::boolean::int                    as isdirect
    , a.content:editeddate::date                          as editeddate
    , a.content:editedby::varchar(150)                    as editedby
    , a.content:custcreateddate::date                     as custcreateddate
    , a.content:custcreatedby::varchar(150)               as custcreatedby
    , a.content:custodialaccountnum::varchar(50)          as custodialaccountnum
    , a.content:cansweepfeestocustacct::boolean::int      as cansweepfeestocustacct
    , a.content:feereqsrc::integer                        as feereqsrc
    , a.content:isdefault::boolean::int                   as isdefault
    , a.content:iscreatedistribution::boolean::int        as iscreatedistribution
    , a.content:masteracctcode::varchar(50)               as masteracctcode
    , a.content:fksweepproductclass::integer              as fksweepproductclass
    , a.content:isqpetransexcluded::boolean::int          as isqpetransexcluded
    , a.content:isusingequityblocktrades::boolean::int    as isusingequityblocktrades
    , a.content:is2parttrading::boolean::int              as is2parttrading
    , a.content:isuseb50setup::boolean::int               as isuseb50setup
    , a.content:cantransmitafterhours::boolean::int       as cantransmitafterhours
    , a.content:fixversion::varchar(30)                   as fixversion
    , a.content:fixrouting::varchar(20)                   as fixrouting
    , a.content:issupermarket::boolean::int               as issupermarket
    , a.content:ismanual::boolean::int                    as ismanual
    , a.content:allowmanualorderallocate::boolean::int    as allowmanualorderallocate
    , a.content:manualorderallocationclordid::varchar(40) as manualorderallocationclordid
    , a.content:dtcnum::varchar(15)                       as dtcnum
    , a.content:fkcustodiancommonlist::varchar(150)       as fkcustodiancommonlist
    , a.content:directtrading::integer                    as directtrading
    , a.content:downloadscostbasis::boolean::int          as downloadscostbasis
    , a.content:fkfixuploadtarget::integer                as fkfixuploadtarget
    , a.content:brokercommission::double precision        as brokercommission
    , a.content:aggregatesleeves::boolean::int            as aggregatesleeves
    , a.content:mincashbalance::double precision          as mincashbalance
    , a.content:replenishmincash::boolean::int            as replenishmincash
    , a.content:sharetradethreshold::double precision     as sharetradethreshold
    , a.content:fkfeefileuploadtarget::integer            as fkfeefileuploadtarget
    , a.content:fkcustodianglobal::integer                as fkcustodianglobal
    , a.content:description::varchar(1000)                as description
    , a.content:communitiesdirecttrading::varchar(100)    as communitiesdirecttrading
    , a.content:createddate::timestamp                    as createddate
    , a.effective_at::date                                as effective_date
    , a._pk::varchar(200)                                 as _pk

    , a._extracted_at::timestamp_ntz                      as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_custodian'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                     as _is_full
    , a._created_at::timestamp_ntz                        as _created_at
    , a._source_file                                      as _source_file
    , a._checksum                                         as _checksum
from {{ source('orion', 'vw_custodian') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
