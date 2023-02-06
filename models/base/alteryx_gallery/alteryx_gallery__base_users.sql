select
    json:_id:"$oid"::varchar(50)                         as id
  , json:WindowsIdentity:DisplayName::varchar(100)       as display_name
  , json:WindowsIdentity:Name::varchar(100)              as domain_name
  , json:Email::string                                   as email
  , json:Role::string                                    as role
  , json:FirstName::string                               as first_name
  , json:LastName::string                                as last_name
  , json:Active::int                                     as is_active
  , json:ApiEnabled::int                                 as is_api_enabled
  , try_to_timestamp(json:DateAdded:"$date"::string)     as added_at
  , try_to_timestamp(json:DateUpdated:"$date"::string)   as udpated_at
  , try_to_timestamp(json:LastLoginDate:"$date"::string) as last_login_at
  , json:CanCreateCollections::int                       as can_create_collection
  , json:CanSchedule::int                                as can_schedule
  , json:CanSetPriority::int                             as can_set_priority
  , json:CanSetWorkerTag::int                            as can_set_worker_tag
  , _created_at                                          as _created_at
from {{ source('alteryx_gallery', 'users') }}