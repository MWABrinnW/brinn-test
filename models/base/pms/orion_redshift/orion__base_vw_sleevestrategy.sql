select
    ci.clientname                                    as clientname
  , content:fkalclient::integer                      as fkalclient
  , content:pksleevestrategy::integer                as pksleevestrategy
  , content:itemkey::varchar(20)                     as itemkey
  , content:name::varchar(60)                        as name
  , content:contributionallocationmethod::integer    as contributionallocationmethod
  , content:distributionallocationmethod::integer    as distributionallocationmethod
  , content:autorebalfreq::integer                   as autorebalfreq
  , content:autorebalmonth::integer                  as autorebalmonth
  , content:autorebalday::integer                    as autorebalday
  , content:mandate::boolean::int                    as mandate
  , content:fkentity::integer                        as fkentity
  , content:entityenum::integer                      as entityenum
  , content:fksleevestrategyrisktype::integer        as fksleevestrategyrisktype
  , content:strategytype::integer                    as strategytype
  , content:beta::double precision                   as beta
  , content:alpha::double precision                  as alpha
  , content:rsquared::double precision               as rsquared
  , content:drawdown::double precision               as drawdown
  , content:ytd::double precision                    as ytd
  , content:oneyr::double precision                  as oneyr
  , content:threeyr::double precision                as threeyr
  , content:fiveyr::double precision                 as fiveyr
  , content:originalriskscore::double precision      as originalriskscore
  , content:tolerancepercent::double precision       as tolerancepercent
  , content:include::boolean::int                    as include
  , content:userestrictions::boolean::int            as userestrictions
  , content:assetlevelallowed::integer               as assetlevelallowed
  , content:fkmodelagg::integer                      as fkmodelagg
  , content:fkplatform::integer                      as fkplatform
  , content:fksubadvisor::integer                    as fksubadvisor
  , content:targetallocation::double precision       as targetallocation
  , content:contributionallocation::double precision as contributionallocation
  , content:distributionallocation::double precision as distributionallocation
  , content:toleranceupper::double precision         as toleranceupper
  , content:tolerancelower::double precision         as tolerancelower
  , content:sleevetype::integer                      as sleevetype
  , content:autotradetypes::integer                  as autotradetypes
  , content:donottrade::boolean::int                 as donottrade
  , content:riskscore::double precision              as riskscore
  , content:sscreatedby::varchar(60)                 as sscreatedby
  , content:sscreateddate::date                      as sscreateddate
  , content:editedby::varchar(60)                    as editedby
  , content:editeddate::date                         as editeddate
  , content:createddate::timestamp                   as createddate
  , a.effective_at::date                             as effective_date
  , a._pk::varchar(200)                              as _pk
  , a._client::int                                   as _client
  , a._extracted_at                                  as _extracted_at
  , {{ col_is_head(reference=source('orion', 'vw_sleevestrategy'), source_date_col='a.effective_at', reference_date_col='effective_at') }}
  , {{ col_is_current(date_col='a.effective_at::date') }}
  , a._is_full::int                                  as _is_full
  , a._created_at                                    as _created_at
  , a._source_file                                   as _source_file
  , a._checksum                                      as _checksum
from {{ source('orion', 'vw_sleevestrategy') }} a
join {{ ref('orion__base_vw_clientinfo') }}         ci
     on a._client::int = ci.pkalclient
