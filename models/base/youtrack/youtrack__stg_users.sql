select
    json:id::text(200)              as id
    , json:fullName::text(200)      as full_name
    , json:email::text(200)         as email--noqa: RF04
    , json:login::text(200)         as login
    , json:profiles:"id"::text(200) as profiles
    , json:guest::text(200)         as guest
    , json:banned::text(200)        as banned
    , json:online::text(200)        as online
    , json:avatarUrl::text(200)     as avatar_url
    --, json                          as _json
    , _created_at::timestamp_ntz    as _created_at
    , _updated_at::timestamp_ntz    as _updated_at
    , _id::int                      as _id
from {{ source('youtrack','users') }}
