select
    ci.clientname                                        as clientname
    , ci.system_name                                     as system_name
    , ci.system_instance                                 as system_instance
    , ci.system_key                                      as system_key
    , ci.firm_source                                     as firm_source
    , a.content:fkalclient::integer                      as fkalclient
    , a.content:pksleevestrategy::integer                as pksleevestrategy
    , a.content:itemkey::varchar(20)                     as itemkey
    , a.content:name::varchar(60)                        as name
    , a.content:contributionallocationmethod::integer    as contributionallocationmethod
    , a.content:distributionallocationmethod::integer    as distributionallocationmethod
    , a.content:autorebalfreq::integer                   as autorebalfreq
    , a.content:autorebalmonth::integer                  as autorebalmonth
    , a.content:autorebalday::integer                    as autorebalday
    , a.content:mandate::boolean::int                    as mandate
    , a.content:fkentity::integer                        as fkentity
    , a.content:entityenum::integer                      as entityenum
    , a.content:fksleevestrategyrisktype::integer        as fksleevestrategyrisktype
    , a.content:strategytype::integer                    as strategytype
    , a.content:beta::double precision                   as beta
    , a.content:alpha::double precision                  as alpha
    , a.content:rsquared::double precision               as rsquared
    , a.content:drawdown::double precision               as drawdown
    , a.content:ytd::double precision                    as ytd
    , a.content:oneyr::double precision                  as oneyr
    , a.content:threeyr::double precision                as threeyr
    , a.content:fiveyr::double precision                 as fiveyr
    , a.content:originalriskscore::double precision      as originalriskscore
    , a.content:tolerancepercent::double precision       as tolerancepercent
    , a.content:include::boolean::int                    as include
    , a.content:userestrictions::boolean::int            as userestrictions
    , a.content:assetlevelallowed::integer               as assetlevelallowed
    , a.content:fkmodelagg::integer                      as fkmodelagg
    , a.content:fkplatform::integer                      as fkplatform
    , a.content:fksubadvisor::integer                    as fksubadvisor
    , a.content:targetallocation::double precision       as targetallocation
    , a.content:contributionallocation::double precision as contributionallocation
    , a.content:distributionallocation::double precision as distributionallocation
    , a.content:toleranceupper::double precision         as toleranceupper
    , a.content:tolerancelower::double precision         as tolerancelower
    , a.content:sleevetype::integer                      as sleevetype
    , a.content:autotradetypes::integer                  as autotradetypes
    , a.content:donottrade::boolean::int                 as donottrade
    , a.content:riskscore::double precision              as riskscore
    , a.content:sscreatedby::varchar(60)                 as sscreatedby
    , a.content:sscreateddate::date                      as sscreateddate
    , a.content:editedby::varchar(60)                    as editedby
    , a.content:editeddate::date                         as editeddate
    , a.content:createddate::timestamp                   as createddate
    , a.effective_at::date                               as effective_date
    , a._pk::varchar(200)                                as _pk

    , a._extracted_at::timestamp_ntz                     as _extracted_at
    , {{ col_is_head(reference=source('orion', 'vw_sleevestrategy'),
        source_date_col='a.effective_at',
        reference_date_col='effective_at') }}
    , {{ col_is_current(date_col='a.effective_at::date') }}
    , a._is_full::int                                    as _is_full
    , a._created_at::timestamp_ntz                       as _created_at
    , a._source_file                                     as _source_file
    , a._checksum                                        as _checksum
from {{ source('orion', 'vw_sleevestrategy') }} as a
inner join {{ ref('orion__base_vw_clientinfo') }} as ci
    on a.content:fkalclient::int = ci.pkalclient
