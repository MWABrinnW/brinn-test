select
    ci.clientname                                    as clientname
  , content:fkalclient::integer                      as fkalclient
  , content:pkregistration::integer                  as pkregistration
  , content:fkclient::integer                        as fkclient
  , content:fkpersonal::integer                      as fkpersonal
  , content:regcreateddate::date                     as regcreateddate
  , content:regcreatedby::varchar(200)               as regcreatedby
  , content:custacctcode::varchar(50)                as custacctcode
  , content:netincome::double precision              as netincome
  , content:networth::double precision               as networth
  , content:risktol::integer                         as risktol
  , content:stockperc::varchar(6)                    as stockperc
  , content:returnobjective::varchar(25)             as returnobjective
  , content:isactive::boolean::int                   as isactive
  , content:investmentamt::double precision          as investmentamt
  , content:editeddate::date                         as editeddate
  , content:editedby::varchar(200)                   as editedby
  , content:fkregistrationtype::integer              as fkregistrationtype
  , content:investmentobjective::varchar(25)         as investmentobjective
  , content:timehorizon::varchar(25)                 as timehorizon
  , content:isreadytotrade::integer                  as isreadytotrade
  , content:dtnewacctsent::varchar(10)               as dtnewacctsent
  , content:importkey::varchar(20)                   as importkey
  , content:riskbudget::integer                      as riskbudget
  , content:islifestyleoption::boolean::int          as islifestyleoption
  , content:dateofdeath::date                        as dateofdeath
  , content:fkpersonal_lexisnexis::integer           as fkpersonal_lexisnexis
  , content:targetspendrate::double precision        as targetspendrate
  , content:targetdollaramount::double precision     as targetdollaramount
  , content:targetdate::date                         as targetdate
  , content:fkpersonaldeceased::integer              as fkpersonaldeceased
  , content:isrtqlocked::boolean::int                as isrtqlocked
  , content:sleeveisactive::boolean::int             as sleeveisactive
  , content:custodialaccountnumber::varchar(60)      as custodialaccountnumber
  , content:contributionallocationmethod::integer    as contributionallocationmethod
  , content:distributionallocationmethod::integer    as distributionallocationmethod
  , content:corporateactionallocationmethod::integer as corporateactionallocationmethod
  , content:sleeveregcreatedby::varchar(60)          as sleeveregcreatedby
  , content:sleeveregcreateddate::date               as sleeveregcreateddate
  , content:sleeveregeditedby::varchar(60)           as sleeveregeditedby
  , content:sleeveregediteddate::date                as sleeveregediteddate
  , content:lastsuffixused::integer                  as lastsuffixused
  , content:autorebalfreq::integer                   as autorebalfreq
  , content:autorebalmonth::integer                  as autorebalmonth
  , content:autorebalday::integer                    as autorebalday
  , content:mandate::boolean::int                    as mandate
  , content:fksleevestrategy::integer                as fksleevestrategy
  , content:eclipsefirmid::integer                   as eclipsefirmid
  , content:tolerancepercent::double precision       as tolerancepercent
  , content:fkbillfeeschedule::integer               as fkbillfeeschedule
  , content:fkbillmasterpayoutschedule::integer      as fkbillmasterpayoutschedule
  , content:upcomingswp::boolean::int                as upcomingswp
  , content:fksleevestrategyaggregate::integer       as fksleevestrategyaggregate
  , content:isdonottrade::boolean::int               as isdonottrade
  , content:needsupdate::boolean::int                as needsupdate
  , content:needsupdatereason::varchar(300)          as needsupdatereason
  , content:createddate::timestamp                   as createddate
  , a.effective_at::date                             as effective_date
  , a._pk::varchar(200)                              as _pk
  , a._client::int                                   as _client
  , a._extracted_at                                  as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_registration'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                  as _is_full
  , a._created_at                                    as _created_at
  , a._source_file                                   as _source_file
  , a._checksum                                      as _checksum
from {{ source('orion', 'vw_registration') }} a
join {{ ref('orion__base_vw_clientinfo') }}   ci
     on a._client::int = ci.pkalclient
