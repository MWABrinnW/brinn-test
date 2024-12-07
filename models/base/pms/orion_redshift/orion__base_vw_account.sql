select
    ci.clientname                                              as clientname
    , ci.system_name                                           as system_name
    , ci.system_instance                                       as system_instance
    , ci.system_key                                            as system_key
    , ci.firm_source                                           as firm_source
    , a.content:fkalclient::integer                            as fkalclient
    , a.content:pkaccount::integer                             as pkaccount
    , a.content:fkregistration::integer                        as fkregistration
    , a.content:fkfundfamily::integer                          as fkfundfamily
    , a.content:fkshareclass::integer                          as fkshareclass
    , a.content:fkplatform::integer                            as fkplatform
    , a.content:fkcustodian::integer                           as fkcustodian
    , a.content:isactive::boolean::int                         as isactive
    , a.content:issweepacct::boolean::int                      as issweepacct
    , a.content:acctcreateddate::date                          as acctcreateddate
    , a.content:acctcreatedby::varchar(50)                     as acctcreatedby
    , a.content:editeddate::date                               as editeddate
    , a.content:editedby::varchar(100)                         as editedby
    , a.content:provider::varchar(10)                          as provider
    , a.content:canceldate::date                               as canceldate
    , a.content:cancelvalue::double precision                  as cancelvalue
    , a.content:istradingblocked::boolean::int                 as istradingblocked
    , a.content:tradinginstr::varchar(512)                     as tradinginstr
    , a.content:outsideid::varchar(50)                         as outsideid
    , a.content:groupnum::varchar(25)                          as groupnum
    , a.content:fksubadvisor::integer                          as fksubadvisor
    , a.content:importkey::varchar(20)                         as importkey
    , a.content:acctstartdate::date                            as acctstartdate
    , a.content:acctstartvalue::double precision               as acctstartvalue
    , a.content:isorigsmcacct::boolean::int                    as isorigsmcacct
    , a.content:fkplan::integer                                as fkplan
    , a.content:accountstatus::integer                         as accountstatus
    , a.content:isphoneauthorized::boolean::int                as isphoneauthorized
    , a.content:fkaccounthistory::integer                      as fkaccounthistory
    , a.content:fksweepasset::integer                          as fksweepasset
    , a.content:initialpurchasedate::timestamp                 as initialpurchasedate
    , a.content:fkaccounthistoryunique::integer                as fkaccounthistoryunique
    , a.content:ismanaged::boolean::int                        as ismanaged
    , a.content:fkdownloadsource::integer                      as fkdownloadsource
    , a.content:fkaccounthistorybilling::integer               as fkaccounthistorybilling
    , a.content:iswrapmanaged::boolean::int                    as iswrapmanaged
    , a.content:isdiscretionary::boolean::int                  as isdiscretionary
    , a.content:riskscore::double precision                    as riskscore
    , a.content:fkportfoliogroupcomposite::integer             as fkportfoliogroupcomposite
    , a.content:fkaccounthistorybillingunique::integer         as fkaccounthistorybillingunique
    , a.content:ispositiononlyrecon::boolean::int              as ispositiononlyrecon
    , a.content:signaturestatus::varchar(100)                  as signaturestatus
    , a.content:eclipsefirmid::integer                         as eclipsefirmid
    , a.content:ishistorical::boolean::int                     as ishistorical
    , a.content:currentdownloaderror::varchar(512)             as currentdownloaderror
    , a.content:prevdownloaderror::varchar(512)                as prevdownloaderror
    , a.content:isunfunded::boolean::int                       as isunfunded
    , a.content:isbundled::boolean::int                        as isbundled
    , a.content:isexcludedfromfirmassets::boolean::int         as isexcludedfromfirmassets
    , a.content:hassloa::boolean::int                          as hassloa
    , a.content:sloadate::timestamp                            as sloadate
    , a.content:thirdparty::varchar(50)                        as thirdparty
    , a.content:isaffiliated::boolean::int                     as isaffiliated
    , a.content:isadvreportable::boolean::int                  as isadvreportable
    , a.content:is13freportable::boolean::int                  as is13freportable
    , a.content:iswrapsponsored::boolean::int                  as iswrapsponsored
    , a.content:isops::boolean::int                            as isops
    , a.content:isauareportable::boolean::int                  as isauareportable
    , a.content:custodialrepcode::varchar(50)                  as custodialrepcode
    , a.content:fkadvcustodytype::integer                      as fkadvcustodytype
    , a.content:primebrokerageagreement::boolean::int          as primebrokerageagreement
    , a.content:marginagreement::boolean::int                  as marginagreement
    , a.content:optionlevel::integer                           as optionlevel
    , a.content:acctcode::varchar(100)                         as acctcode
    , a.content:secondaryacctcode::varchar(100)                as secondaryacctcode
    , a.content:pkmdlaccount::integer                          as pkmdlaccount
    , a.content:rebalanceyn::boolean::int                      as rebalanceyn
    , a.content:isoutsidemodel::boolean::int                   as isoutsidemodel
    , a.content:mincashbalance::double precision               as mincashbalance
    , a.content:mdlacctcreateddate::date                       as mdlacctcreateddate
    , a.content:mdlacctcreatedby::varchar(50)                  as mdlacctcreatedby
    , a.content:mdlacctediteddate::date                        as mdlacctediteddate
    , a.content:mdlaccteditedby::varchar(50)                   as mdlaccteditedby
    , a.content:oldclientid::integer                           as oldclientid
    , a.content:fkmodelagg::integer                            as fkmodelagg
    , a.content:fundlist::varchar(60)                          as fundlist
    , a.content:mincashbalancetype::integer                    as mincashbalancetype
    , a.content:fkmodelaggnewmoney::integer                    as fkmodelaggnewmoney
    , a.content:autorebalfreq::integer                         as autorebalfreq
    , a.content:autorebalmonth::integer                        as autorebalmonth
    , a.content:autorebalday::integer                          as autorebalday
    , a.content:lastrebalanced::date                           as lastrebalanced
    , a.content:replenishmincash::boolean::int                 as replenishmincash
    , a.content:fkdollarmodel::integer                         as fkdollarmodel
    , a.content:dollarmodelamount::double precision            as dollarmodelamount
    , a.content:cashliability::double precision                as cashliability
    , a.content:expiremincash::double precision                as expiremincash
    , a.content:expiremincashtype::integer                     as expiremincashtype
    , a.content:expiremincashdate::date                        as expiremincashdate
    , a.content:targetallocation::double precision             as targetallocation
    , a.content:contributionallocation::double precision       as contributionallocation
    , a.content:distributionallocation::double precision       as distributionallocation
    , a.content:corporateactionallocation::double precision    as corporateactionallocation
    , a.content:toleranceupper::double precision               as toleranceupper
    , a.content:tolerancelower::double precision               as tolerancelower
    , a.content:sleeveacctcreatedby::varchar(60)               as sleeveacctcreatedby
    , a.content:sleeveacctcreateddate::date                    as sleeveacctcreateddate
    , a.content:sleeveaccteditedby::varchar(60)                as sleeveaccteditedby
    , a.content:sleeveacctediteddate::date                     as sleeveacctediteddate
    , a.content:master::boolean::int                           as master
    , a.content:sleevetype::integer                            as sleevetype
    , a.content:autotradetypes::integer                        as autotradetypes
    , a.content:autotraderequested::date                       as autotraderequested
    , a.content:autotraderequestedby::varchar(150)             as autotraderequestedby
    , a.content:autotradeprocessed::date                       as autotradeprocessed
    , a.content:suspendautocontribuntil::date                  as suspendautocontribuntil
    , a.content:targetbalancetype::integer                     as targetbalancetype
    , a.content:donottrade::boolean::int                       as donottrade
    , a.content:iscustomized::boolean::int                     as iscustomized
    , a.content:fksleevestrategydetail::integer                as fksleevestrategydetail
    , a.content:fksleevestrategy::integer                      as fksleevestrategy
    , a.content:sleevestrategytoleranceupper::double precision as sleevestrategytoleranceupper
    , a.content:sleevestrategytolerancelower::double precision as sleevestrategytolerancelower
    , a.content:fkbusinessline::integer                        as fkbusinessline
    , a.content:fkpersonalbusinessline::integer                as fkpersonalbusinessline
    , a.content:businesslineemployeecount::integer             as businesslineemployeecount
    , a.content:businesslinestartdate::date                    as businesslinestartdate
    , a.content:issma::boolean::int                            as issma
    , a.content:eclipsesma::integer                            as eclipsesma
    , a.content:fksmaasset::integer                            as fksmaasset
    , a.content:smacreatedby::varchar(150)                     as smacreatedby
    , a.content:smacreateddate::date                           as smacreateddate
    , a.content:smaeditedby::varchar(150)                      as smaeditedby
    , a.content:smaediteddate::date                            as smaediteddate
    , a.content:createddate::timestamp                         as createddate
    , a.effective_at::date                                     as effective_date
    , a._pk::varchar(200)                                      as _pk
    , a._extracted_at::timestamp_ntz                           as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_account'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                          as _is_full
    , a._created_at::timestamp_ntz                             as _created_at
    , a._source_file                                           as _source_file
    , a._checksum                                              as _checksum
from {{ source('orion', 'vw_account') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
