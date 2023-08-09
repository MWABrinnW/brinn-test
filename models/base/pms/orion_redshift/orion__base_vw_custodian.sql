select
    ci.clientname                                     as clientname
  , content:fkalclient::integer                       as fkalclient
  , content:pkcustodian::integer                      as pkcustodian
  , content:fkpersonal::integer                       as fkpersonal
  , content:name::varchar(50)                         as name
  , content:code::varchar(60)                         as code
  , content:sweeplevel::integer                       as sweeplevel
  , content:isdirect::boolean::int                    as isdirect
  , content:editeddate::date                          as editeddate
  , content:editedby::varchar(150)                    as editedby
  , content:custcreateddate::date                     as custcreateddate
  , content:custcreatedby::varchar(150)               as custcreatedby
  , content:custodialaccountnum::varchar(50)          as custodialaccountnum
  , content:cansweepfeestocustacct::boolean::int      as cansweepfeestocustacct
  , content:feereqsrc::integer                        as feereqsrc
  , content:isdefault::boolean::int                   as isdefault
  , content:iscreatedistribution::boolean::int        as iscreatedistribution
  , content:masteracctcode::varchar(50)               as masteracctcode
  , content:fksweepproductclass::integer              as fksweepproductclass
  , content:isqpetransexcluded::boolean::int          as isqpetransexcluded
  , content:isusingequityblocktrades::boolean::int    as isusingequityblocktrades
  , content:is2parttrading::boolean::int              as is2parttrading
  , content:isuseb50setup::boolean::int               as isuseb50setup
  , content:cantransmitafterhours::boolean::int       as cantransmitafterhours
  , content:fixversion::varchar(30)                   as fixversion
  , content:fixrouting::varchar(20)                   as fixrouting
  , content:issupermarket::boolean::int               as issupermarket
  , content:ismanual::boolean::int                    as ismanual
  , content:allowmanualorderallocate::boolean::int    as allowmanualorderallocate
  , content:manualorderallocationclordid::varchar(40) as manualorderallocationclordid
  , content:dtcnum::varchar(15)                       as dtcnum
  , content:fkcustodiancommonlist::varchar(150)       as fkcustodiancommonlist
  , content:directtrading::integer                    as directtrading
  , content:downloadscostbasis::boolean::int          as downloadscostbasis
  , content:fkfixuploadtarget::integer                as fkfixuploadtarget
  , content:brokercommission::double precision        as brokercommission
  , content:aggregatesleeves::boolean::int            as aggregatesleeves
  , content:mincashbalance::double precision          as mincashbalance
  , content:replenishmincash::boolean::int            as replenishmincash
  , content:sharetradethreshold::double precision     as sharetradethreshold
  , content:fkfeefileuploadtarget::integer            as fkfeefileuploadtarget
  , content:fkcustodianglobal::integer                as fkcustodianglobal
  , content:description::varchar(1000)                as description
  , content:communitiesdirecttrading::varchar(100)    as communitiesdirecttrading
  , content:createddate::timestamp                    as createddate
  , a.effective_at::date                              as effective_date
  , a._pk::varchar(200)                               as _pk
  , a._client::int                                    as _client
  , a._extracted_at                                   as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_custodian'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                   as _is_full
  , a._created_at                                     as _created_at
  , a._source_file                                    as _source_file
  , a._checksum                                       as _checksum
from {{ source('orion', 'stg_vw_custodian') }} a
join {{ ref('orion__base_vw_clientinfo') }}    ci
     on a._client::int = ci.pkalclient
