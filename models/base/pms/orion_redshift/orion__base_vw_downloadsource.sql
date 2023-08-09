select
    ci.clientname                                          as clientname
  , content:fkalclient::integer                            as fkalclient
  , content:pkdownloadsource::integer                      as pkdownloadsource
  , content:fkdownloadformat::integer                      as fkdownloadformat
  , content:downloaddesc::varchar(60)                      as downloaddesc
  , content:transmitmethod::integer                        as transmitmethod
  , content:url::varchar(300)                              as url
  , content:filepattern::varchar(1000)                     as filepattern
  , content:userid::varchar(40)                            as userid
  , content:password::varchar(40)                          as password
  , content:zippassword::varchar(40)                       as zippassword
  , content:pgpuserid::varchar(40)                         as pgpuserid
  , content:transperctolerance::double precision           as transperctolerance
  , content:transdaystolerance::integer                    as transdaystolerance
  , content:deletesourcefile::boolean::int                 as deletesourcefile
  , content:cashcusip::varchar(200)                        as cashcusip
  , content:allowpriceimport::boolean::int                 as allowpriceimport
  , content:allowsecondaryacctcodematch::boolean::int      as allowsecondaryacctcodematch
  , content:allowacctcodematch::boolean::int               as allowacctcodematch
  , content:allownameimport::boolean::int                  as allownameimport
  , content:allowpositionimport::boolean::int              as allowpositionimport
  , content:allowtransactionimport::boolean::int           as allowtransactionimport
  , content:allowsecurityimport::boolean::int              as allowsecurityimport
  , content:allowcorpactionimport::boolean::int            as allowcorpactionimport
  , content:allowdivimport::boolean::int                   as allowdivimport
  , content:patternmatchtype::integer                      as patternmatchtype
  , content:baseacctlength::integer                        as baseacctlength
  , content:usereversal::boolean::int                      as usereversal
  , content:isactive::boolean::int                         as isactive
  , content:allowtrandetailimport::boolean::int            as allowtrandetailimport
  , content:allowgenericimport::boolean::int               as allowgenericimport
  , content:allowcostbasisimport::boolean::int             as allowcostbasisimport
  , content:isautohouseholding::boolean::int               as isautohouseholding
  , content:isacctcreation::boolean::int                   as isacctcreation
  , content:isunverifiedsells::boolean::int                as isunverifiedsells
  , content:note::varchar(1000)                            as note
  , content:custodiancommoncode::varchar(20)               as custodiancommoncode
  , content:fkcustodiancommon::integer                     as fkcustodiancommon
  , content:ignorerepverify::boolean::int                  as ignorerepverify
  , content:donotusebulk::boolean::int                     as donotusebulk
  , content:altfilepattern::varchar(1000)                  as altfilepattern
  , content:allowpricezero::boolean::int                   as allowpricezero
  , content:recontargettime::date                          as recontargettime
  , content:comparepositionvalue::boolean::int             as comparepositionvalue
  , content:newaccounts::integer                           as newaccounts
  , content:runassetvaluecomparison::boolean::int          as runassetvaluecomparison
  , content:editeddate::date                               as editeddate
  , content:editedby::varchar(60)                          as editedby
  , content:downloadcreateddate::date                      as downloadcreateddate
  , content:downloadcreatedby::varchar(60)                 as downloadcreatedby
  , content:fkserviceteamrecon::integer                    as fkserviceteamrecon
  , content:fkserviceteammember::integer                   as fkserviceteammember
  , content:alwayscreatenewregistration::boolean::int      as alwayscreatenewregistration
  , content:allowacctcodematchwozero::boolean::int         as allowacctcodematchwozero
  , content:issourceexclusioncb::boolean::int              as issourceexclusioncb
  , content:issourceexclusiontran::boolean::int            as issourceexclusiontran
  , content:noorionpricecopy::boolean::int                 as noorionpricecopy
  , content:namepercmatch::double precision                as namepercmatch
  , content:pospercmatch::double precision                 as pospercmatch
  , content:tranpercmatch::double precision                as tranpercmatch
  , content:archivefiles::boolean::int                     as archivefiles
  , content:regbasenumber::integer                         as regbasenumber
  , content:nacsuppression::boolean::int                   as nacsuppression
  , content:positiononlyreconcile::integer                 as positiononlyreconcile
  , content:dailyaccrualtolerance::double precision        as dailyaccrualtolerance
  , content:isfixsmallbalance::boolean::int                as isfixsmallbalance
  , content:isdividendtransactioncombination::boolean::int as isdividendtransactioncombination
  , content:nextscheduledrundate::date                     as nextscheduledrundate
  , content:allowbeneficiaryimport::boolean::int           as allowbeneficiaryimport
  , content:issleeveeligible::boolean::int                 as issleeveeligible
  , content:isorionenterpriseenabled::boolean::int         as isorionenterpriseenabled
  , content:allowsystematicimport::boolean::int            as allowsystematicimport
  , content:allowrmdimport::boolean::int                   as allowrmdimport
  , content:allowbankingimport::boolean::int               as allowbankingimport
  , content:allowduplicateassets::boolean::int             as allowduplicateassets
  , content:allowpropername::boolean::int                  as allowpropername
  , content:advreportable::boolean::int                    as advreportable
  , content:thirteenfreportable::boolean::int              as thirteenfreportable
  , content:autocreatestartingvalues::boolean::int         as autocreatestartingvalues
  , content:removesettledatetrades::boolean::int           as removesettledatetrades
  , content:principalandincome::boolean::int               as principalandincome
  , content:underreview::boolean::int                      as underreview
  , content:createtransactioninpendingstatus::boolean::int as createtransactioninpendingstatus
  , content:createddate::timestamp                         as createddate
  , a.effective_at::date                                   as effective_date
  , a._pk::varchar(200)                                    as _pk
  , a._client::int                                         as _client
  , a._extracted_at                                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'stg_vw_downloadsource'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                        as _is_full
  , a._created_at                                          as _created_at
  , a._source_file                                         as _source_file
  , a._checksum                                            as _checksum
from {{ source('orion', 'stg_vw_downloadsource') }} a
join {{ ref('orion__base_vw_clientinfo') }}         ci
     on a._client::int = ci.pkalclient
