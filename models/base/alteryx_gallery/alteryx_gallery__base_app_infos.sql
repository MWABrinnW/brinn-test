select
    ai.json:ServiceId::string                                                                         as service_id-- "app_id"
    , ai.json:PublishedRevision:Applications[0]:FileName::varchar(100)                                as file_name
    , nullif(trim(ai.json:PublishedRevision:Applications[0]:MetaInfo:Author) , '')::varchar(100)      as author
    , ai.json:PublishedRevision:Applications[0]:MetaInfo:Name::varchar(100)                           as name
    , nullif(trim(ai.json:PublishedRevision:Applications[0]:MetaInfo:Description) , '')::varchar(500) as description
    , nullif(trim(ai.json:CreatedBy) , '')::varchar(50)                                               as created_by
    , ai.json:IsPublic::int                                                                           as is_public
    , ai.json:RunDisabled::int                                                                        as run_disabled
    , ai.json:SourceAppId::string                                                                     as source_app_id
    , ai.json:SubscriptionId::string                                                                  as subscription_id
    , ai.json:TotalRunCount::int                                                                      as total_run_count
    , ai.json:IsDeleted::int                                                                          as is_deleted
    , ai.json:IsReadyForMigration::boolean                                                            as isreadyformigration
    , ai.json:PublishedRevision:Applications::string                                                  as publishedrevision
    , ai._created_at                                                                                  as _created_at
from {{ source('alteryx_gallery', 'appinfos') }} as ai
