select
    ci.clientname                                          as clientname
  , content:fkalclient::integer                            as fkalclient
  , content:pkaccount::integer                             as pkaccount
  , content:fkregistration::integer                        as fkregistration
  , content:fkfundfamily::integer                          as fkfundfamily
  , content:fkshareclass::integer                          as fkshareclass
  , content:fkplatform::integer                            as fkplatform
  , content:fkcustodian::integer                           as fkcustodian
  , content:isactive::boolean::int                         as isactive
  , content:issweepacct::boolean::int                      as issweepacct
  , content:acctcreateddate::date                          as acctcreateddate
  , content:acctcreatedby::varchar(50)                     as acctcreatedby
  , content:editeddate::date                               as editeddate
  , content:editedby::varchar(100)                         as editedby
  , content:provider::varchar(10)                          as provider
  , content:canceldate::date                               as canceldate
  , content:cancelvalue::double precision                  as cancelvalue
  , content:istradingblocked::boolean::int                 as istradingblocked
  , content:tradinginstr::varchar(512)                     as tradinginstr
  , content:outsideid::varchar(50)                         as outsideid
  , content:groupnum::varchar(25)                          as groupnum
  , content:fksubadvisor::integer                          as fksubadvisor
  , content:importkey::varchar(20)                         as importkey
  , content:acctstartdate::date                            as acctstartdate
  , content:acctstartvalue::double precision               as acctstartvalue
  , content:isorigsmcacct::boolean::int                    as isorigsmcacct
  , content:fkplan::integer                                as fkplan
  , content:accountstatus::integer                         as accountstatus
  , content:isphoneauthorized::boolean::int                as isphoneauthorized
  , content:fkaccounthistory::integer                      as fkaccounthistory
  , content:fksweepasset::integer                          as fksweepasset
  , content:initialpurchasedate::timestamp                 as initialpurchasedate
  , content:fkaccounthistoryunique::integer                as fkaccounthistoryunique
  , content:ismanaged::boolean::int                        as ismanaged
  , content:fkdownloadsource::integer                      as fkdownloadsource
  , content:fkaccounthistorybilling::integer               as fkaccounthistorybilling
  , content:iswrapmanaged::boolean::int                    as iswrapmanaged
  , content:isdiscretionary::boolean::int                  as isdiscretionary
  , content:riskscore::double precision                    as riskscore
  , content:fkportfoliogroupcomposite::integer             as fkportfoliogroupcomposite
  , content:fkaccounthistorybillingunique::integer         as fkaccounthistorybillingunique
  , content:ispositiononlyrecon::boolean::int              as ispositiononlyrecon
  , content:signaturestatus::varchar(100)                  as signaturestatus
  , content:eclipsefirmid::integer                         as eclipsefirmid
  , content:ishistorical::boolean::int                     as ishistorical
  , content:currentdownloaderror::varchar(512)             as currentdownloaderror
  , content:prevdownloaderror::varchar(512)                as prevdownloaderror
  , content:isunfunded::boolean::int                       as isunfunded
  , content:isbundled::boolean::int                        as isbundled
  , content:isexcludedfromfirmassets::boolean::int         as isexcludedfromfirmassets
  , content:hassloa::boolean::int                          as hassloa
  , content:sloadate::timestamp                            as sloadate
  , content:thirdparty::varchar(50)                        as thirdparty
  , content:isaffiliated::boolean::int                     as isaffiliated
  , content:isadvreportable::boolean::int                  as isadvreportable
  , content:is13freportable::boolean::int                  as is13freportable
  , content:iswrapsponsored::boolean::int                  as iswrapsponsored
  , content:isops::boolean::int                            as isops
  , content:isauareportable::boolean::int                  as isauareportable
  , content:custodialrepcode::varchar(50)                  as custodialrepcode
  , content:fkadvcustodytype::integer                      as fkadvcustodytype
  , content:primebrokerageagreement::boolean::int          as primebrokerageagreement
  , content:marginagreement::boolean::int                  as marginagreement
  , content:optionlevel::integer                           as optionlevel
  , content:acctcode::varchar(100)                         as acctcode
  , content:secondaryacctcode::varchar(100)                as secondaryacctcode
  , content:pkmdlaccount::integer                          as pkmdlaccount
  , content:rebalanceyn::boolean::int                      as rebalanceyn
  , content:isoutsidemodel::boolean::int                   as isoutsidemodel
  , content:mincashbalance::double precision               as mincashbalance
  , content:mdlacctcreateddate::date                       as mdlacctcreateddate
  , content:mdlacctcreatedby::varchar(50)                  as mdlacctcreatedby
  , content:mdlacctediteddate::date                        as mdlacctediteddate
  , content:mdlaccteditedby::varchar(50)                   as mdlaccteditedby
  , content:oldclientid::integer                           as oldclientid
  , content:fkmodelagg::integer                            as fkmodelagg
  , content:fundlist::varchar(60)                          as fundlist
  , content:mincashbalancetype::integer                    as mincashbalancetype
  , content:fkmodelaggnewmoney::integer                    as fkmodelaggnewmoney
  , content:autorebalfreq::integer                         as autorebalfreq
  , content:autorebalmonth::integer                        as autorebalmonth
  , content:autorebalday::integer                          as autorebalday
  , content:lastrebalanced::date                           as lastrebalanced
  , content:replenishmincash::boolean::int                 as replenishmincash
  , content:fkdollarmodel::integer                         as fkdollarmodel
  , content:dollarmodelamount::double precision            as dollarmodelamount
  , content:cashliability::double precision                as cashliability
  , content:expiremincash::double precision                as expiremincash
  , content:expiremincashtype::integer                     as expiremincashtype
  , content:expiremincashdate::date                        as expiremincashdate
  , content:targetallocation::double precision             as targetallocation
  , content:contributionallocation::double precision       as contributionallocation
  , content:distributionallocation::double precision       as distributionallocation
  , content:corporateactionallocation::double precision    as corporateactionallocation
  , content:toleranceupper::double precision               as toleranceupper
  , content:tolerancelower::double precision               as tolerancelower
  , content:sleeveacctcreatedby::varchar(60)               as sleeveacctcreatedby
  , content:sleeveacctcreateddate::date                    as sleeveacctcreateddate
  , content:sleeveaccteditedby::varchar(60)                as sleeveaccteditedby
  , content:sleeveacctediteddate::date                     as sleeveacctediteddate
  , content:master::boolean::int                           as master
  , content:sleevetype::integer                            as sleevetype
  , content:autotradetypes::integer                        as autotradetypes
  , content:autotraderequested::date                       as autotraderequested
  , content:autotraderequestedby::varchar(150)             as autotraderequestedby
  , content:autotradeprocessed::date                       as autotradeprocessed
  , content:suspendautocontribuntil::date                  as suspendautocontribuntil
  , content:targetbalancetype::integer                     as targetbalancetype
  , content:donottrade::boolean::int                       as donottrade
  , content:iscustomized::boolean::int                     as iscustomized
  , content:fksleevestrategydetail::integer                as fksleevestrategydetail
  , content:fksleevestrategy::integer                      as fksleevestrategy
  , content:sleevestrategytoleranceupper::double precision as sleevestrategytoleranceupper
  , content:sleevestrategytolerancelower::double precision as sleevestrategytolerancelower
  , content:fkbusinessline::integer                        as fkbusinessline
  , content:fkpersonalbusinessline::integer                as fkpersonalbusinessline
  , content:businesslineemployeecount::integer             as businesslineemployeecount
  , content:businesslinestartdate::date                    as businesslinestartdate
  , content:issma::boolean::int                            as issma
  , content:eclipsesma::integer                            as eclipsesma
  , content:fksmaasset::integer                            as fksmaasset
  , content:smacreatedby::varchar(150)                     as smacreatedby
  , content:smacreateddate::date                           as smacreateddate
  , content:smaeditedby::varchar(150)                      as smaeditedby
  , content:smaediteddate::date                            as smaediteddate
  , content:createddate::timestamp                         as createddate
  , a.effective_at::date                                   as effective_date
  , a._pk::varchar(200)                                    as _pk
  , a._client::int                                         as _client
  , a._extracted_at                                        as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_account'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                        as _is_full
  , a._created_at                                          as _created_at
  , a._source_file                                         as _source_file
  , a._checksum                                            as _checksum
from {{ source('orion', 'vw_account') }}    a
join {{ ref('orion__base_vw_clientinfo') }} ci
     on a._client::int = ci.pkalclient
