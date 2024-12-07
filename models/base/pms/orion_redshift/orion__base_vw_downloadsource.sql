select
    ci.clientname                                              as clientname
    , ci.system_name                                           as system_name
    , ci.system_instance                                       as system_instance
    , ci.system_key                                            as system_key
    , ci.firm_source                                           as firm_source
    , a.content:fkalclient::integer                            as fkalclient
    , a.content:pkdownloadsource::integer                      as pkdownloadsource
    , a.content:fkdownloadformat::integer                      as fkdownloadformat
    , a.content:downloaddesc::varchar(60)                      as downloaddesc
    , a.content:transmitmethod::integer                        as transmitmethod
    , a.content:url::varchar(300)                              as url
    , a.content:filepattern::varchar(1000)                     as filepattern
    , a.content:userid::varchar(40)                            as userid
    , a.content:password::varchar(40)                          as password
    , a.content:zippassword::varchar(40)                       as zippassword
    , a.content:pgpuserid::varchar(40)                         as pgpuserid
    , a.content:transperctolerance::double precision           as transperctolerance
    , a.content:transdaystolerance::integer                    as transdaystolerance
    , a.content:deletesourcefile::boolean::int                 as deletesourcefile
    , a.content:cashcusip::varchar(200)                        as cashcusip
    , a.content:allowpriceimport::boolean::int                 as allowpriceimport
    , a.content:allowsecondaryacctcodematch::boolean::int      as allowsecondaryacctcodematch
    , a.content:allowacctcodematch::boolean::int               as allowacctcodematch
    , a.content:allownameimport::boolean::int                  as allownameimport
    , a.content:allowpositionimport::boolean::int              as allowpositionimport
    , a.content:allowtransactionimport::boolean::int           as allowtransactionimport
    , a.content:allowsecurityimport::boolean::int              as allowsecurityimport
    , a.content:allowcorpactionimport::boolean::int            as allowcorpactionimport
    , a.content:allowdivimport::boolean::int                   as allowdivimport
    , a.content:patternmatchtype::integer                      as patternmatchtype
    , a.content:baseacctlength::integer                        as baseacctlength
    , a.content:usereversal::boolean::int                      as usereversal
    , a.content:isactive::boolean::int                         as isactive
    , a.content:allowtrandetailimport::boolean::int            as allowtrandetailimport
    , a.content:allowgenericimport::boolean::int               as allowgenericimport
    , a.content:allowcostbasisimport::boolean::int             as allowcostbasisimport
    , a.content:isautohouseholding::boolean::int               as isautohouseholding
    , a.content:isacctcreation::boolean::int                   as isacctcreation
    , a.content:isunverifiedsells::boolean::int                as isunverifiedsells
    , a.content:note::varchar(1000)                            as note
    , a.content:custodiancommoncode::varchar(20)               as custodiancommoncode
    , a.content:fkcustodiancommon::integer                     as fkcustodiancommon
    , a.content:ignorerepverify::boolean::int                  as ignorerepverify
    , a.content:donotusebulk::boolean::int                     as donotusebulk
    , a.content:altfilepattern::varchar(1000)                  as altfilepattern
    , a.content:allowpricezero::boolean::int                   as allowpricezero
    , a.content:recontargettime::date                          as recontargettime
    , a.content:comparepositionvalue::boolean::int             as comparepositionvalue
    , a.content:newaccounts::integer                           as newaccounts
    , a.content:runassetvaluecomparison::boolean::int          as runassetvaluecomparison
    , a.content:editeddate::date                               as editeddate
    , a.content:editedby::varchar(60)                          as editedby
    , a.content:downloadcreateddate::date                      as downloadcreateddate
    , a.content:downloadcreatedby::varchar(60)                 as downloadcreatedby
    , a.content:fkserviceteamrecon::integer                    as fkserviceteamrecon
    , a.content:fkserviceteammember::integer                   as fkserviceteammember
    , a.content:alwayscreatenewregistration::boolean::int      as alwayscreatenewregistration
    , a.content:allowacctcodematchwozero::boolean::int         as allowacctcodematchwozero
    , a.content:issourceexclusioncb::boolean::int              as issourceexclusioncb
    , a.content:issourceexclusiontran::boolean::int            as issourceexclusiontran
    , a.content:noorionpricecopy::boolean::int                 as noorionpricecopy
    , a.content:namepercmatch::double precision                as namepercmatch
    , a.content:pospercmatch::double precision                 as pospercmatch
    , a.content:tranpercmatch::double precision                as tranpercmatch
    , a.content:archivefiles::boolean::int                     as archivefiles
    , a.content:regbasenumber::integer                         as regbasenumber
    , a.content:nacsuppression::boolean::int                   as nacsuppression
    , a.content:positiononlyreconcile::integer                 as positiononlyreconcile
    , a.content:dailyaccrualtolerance::double precision        as dailyaccrualtolerance
    , a.content:isfixsmallbalance::boolean::int                as isfixsmallbalance
    , a.content:isdividendtransactioncombination::boolean::int as isdividendtransactioncombination
    , a.content:nextscheduledrundate::date                     as nextscheduledrundate
    , a.content:allowbeneficiaryimport::boolean::int           as allowbeneficiaryimport
    , a.content:issleeveeligible::boolean::int                 as issleeveeligible
    , a.content:isorionenterpriseenabled::boolean::int         as isorionenterpriseenabled
    , a.content:allowsystematicimport::boolean::int            as allowsystematicimport
    , a.content:allowrmdimport::boolean::int                   as allowrmdimport
    , a.content:allowbankingimport::boolean::int               as allowbankingimport
    , a.content:allowduplicateassets::boolean::int             as allowduplicateassets
    , a.content:allowpropername::boolean::int                  as allowpropername
    , a.content:advreportable::boolean::int                    as advreportable
    , a.content:thirteenfreportable::boolean::int              as thirteenfreportable
    , a.content:autocreatestartingvalues::boolean::int         as autocreatestartingvalues
    , a.content:removesettledatetrades::boolean::int           as removesettledatetrades
    , a.content:principalandincome::boolean::int               as principalandincome
    , a.content:underreview::boolean::int                      as underreview
    , a.content:createtransactioninpendingstatus::boolean::int as createtransactioninpendingstatus
    , a.content:createddate::timestamp                         as createddate
    , a.effective_at::date                                     as effective_date
    , a._pk::varchar(200)                                      as _pk

    , a._extracted_at::timestamp_ntz                           as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_downloadsource'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                          as _is_full
    , a._created_at::timestamp_ntz                             as _created_at
    , a._source_file                                           as _source_file
    , a._checksum                                              as _checksum
from {{ source('orion', 'vw_downloadsource') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
