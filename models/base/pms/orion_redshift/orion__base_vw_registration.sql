select
    ci.clientname                                        as clientname
    , ci.system_name                                     as system_name
    , ci.system_instance                                 as system_instance
    , ci.system_key                                      as system_key
    , ci.firm_source                                     as firm_source
    , a.content:fkalclient::integer                      as fkalclient
    , a.content:pkregistration::integer                  as pkregistration
    , a.content:fkclient::integer                        as fkclient
    , a.content:fkpersonal::integer                      as fkpersonal
    , a.content:regcreateddate::date                     as regcreateddate
    , a.content:regcreatedby::varchar(200)               as regcreatedby
    , a.content:custacctcode::varchar(50)                as custacctcode
    , a.content:netincome::double precision              as netincome
    , a.content:networth::double precision               as networth
    , a.content:risktol::integer                         as risktol
    , a.content:stockperc::varchar(6)                    as stockperc
    , a.content:returnobjective::varchar(25)             as returnobjective
    , a.content:isactive::boolean::int                   as isactive
    , a.content:investmentamt::double precision          as investmentamt
    , a.content:editeddate::date                         as editeddate
    , a.content:editedby::varchar(200)                   as editedby
    , a.content:fkregistrationtype::integer              as fkregistrationtype
    , a.content:investmentobjective::varchar(25)         as investmentobjective
    , a.content:timehorizon::varchar(25)                 as timehorizon
    , a.content:isreadytotrade::integer                  as isreadytotrade
    , a.content:dtnewacctsent::varchar(10)               as dtnewacctsent
    , a.content:importkey::varchar(20)                   as importkey
    , a.content:riskbudget::integer                      as riskbudget
    , a.content:islifestyleoption::boolean::int          as islifestyleoption
    , a.content:dateofdeath::date                        as dateofdeath
    , a.content:fkpersonal_lexisnexis::integer           as fkpersonal_lexisnexis
    , a.content:targetspendrate::double precision        as targetspendrate
    , a.content:targetdollaramount::double precision     as targetdollaramount
    , a.content:targetdate::date                         as targetdate
    , a.content:fkpersonaldeceased::integer              as fkpersonaldeceased
    , a.content:isrtqlocked::boolean::int                as isrtqlocked
    , a.content:sleeveisactive::boolean::int             as sleeveisactive
    , a.content:custodialaccountnumber::varchar(60)      as custodialaccountnumber
    , a.content:contributionallocationmethod::integer    as contributionallocationmethod
    , a.content:distributionallocationmethod::integer    as distributionallocationmethod
    , a.content:corporateactionallocationmethod::integer as corporateactionallocationmethod
    , a.content:sleeveregcreatedby::varchar(60)          as sleeveregcreatedby
    , a.content:sleeveregcreateddate::date               as sleeveregcreateddate
    , a.content:sleeveregeditedby::varchar(60)           as sleeveregeditedby
    , a.content:sleeveregediteddate::date                as sleeveregediteddate
    , a.content:lastsuffixused::integer                  as lastsuffixused
    , a.content:autorebalfreq::integer                   as autorebalfreq
    , a.content:autorebalmonth::integer                  as autorebalmonth
    , a.content:autorebalday::integer                    as autorebalday
    , a.content:mandate::boolean::int                    as mandate
    , a.content:fksleevestrategy::integer                as fksleevestrategy
    , a.content:eclipsefirmid::integer                   as eclipsefirmid
    , a.content:tolerancepercent::double precision       as tolerancepercent
    , a.content:fkbillfeeschedule::integer               as fkbillfeeschedule
    , a.content:fkbillmasterpayoutschedule::integer      as fkbillmasterpayoutschedule
    , a.content:upcomingswp::boolean::int                as upcomingswp
    , a.content:fksleevestrategyaggregate::integer       as fksleevestrategyaggregate
    , a.content:isdonottrade::boolean::int               as isdonottrade
    , a.content:needsupdate::boolean::int                as needsupdate
    , a.content:needsupdatereason::varchar(300)          as needsupdatereason
    , a.content:createddate::timestamp                   as createddate
    , a.effective_at::date                               as effective_date
    , a._pk::varchar(200)                                as _pk

    , a._extracted_at::timestamp_ntz                     as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_registration'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                    as _is_full
    , a._created_at::timestamp_ntz                       as _created_at
    , a._source_file                                     as _source_file
    , a._checksum                                        as _checksum
from {{ source('orion', 'vw_registration') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
