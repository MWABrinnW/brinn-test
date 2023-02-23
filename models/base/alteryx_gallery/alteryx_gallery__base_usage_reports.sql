select
    try_to_timestamp(json:DateTime:"$date"::text)::timestamp as event_at
  , try_to_timestamp(json:ServerDateTime:"$date"::text)      as server_event_at
  , json:Data::variant                                       as data
  , json:DeviceId::varchar(100)                              as device_id
  , json:Guid::varchar(100)                                  as guid
  , json:IpAddress::varchar(100)                             as ip_address
  , json:Cores::int                                          as cores
  , json:Type::int                                           as type
  , json:IsTrial::int                                        as is_trial
  , json:Preview::int                                        as is_preview
  , json:SerialNumber::varchar(100)                          as serial_number
  , json:UserId::varchar(100)                                as user_id
  , json:Version::varchar(100)                               as version
from {{ source('alteryx_gallery', 'usagereports') }}
where true
--   and not (array_contains('SampleModule'::variant, object_keys(json::variant:Data)))
  and json:Data not ilike '%SampleModule%'