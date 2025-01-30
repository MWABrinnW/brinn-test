select
    json:id::text                                          as id
    , json:name::text(200)                                 as full_name
    , json:login::text(200)                                as login
    , json:profile:email:email::text                       as email--noqa: RF04
    , json:groups::variant                                 as groups
    , json:teams::variant                                  as teams
    , json:banned::boolean::int                            as is_banned
    , json:guest::boolean::int                             as is_guest
    , to_timestamp_tz((json:"creationTime"::int) / 1000)   as created_at
    , to_timestamp_tz((json:"lastAccessTime"::int) / 1000) as last_accessed_at
    , _created_at::timestamp_ntz                           as _created_at
    , _updated_at::timestamp_ntz                           as _updated_at
    , _id::int                                             as _id
from {{ source('youtrack','users') }}
