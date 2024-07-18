select
    a.content:articulate360User::boolean       as articulate360user
    , a.content:email::varchar(200)            as email
    , a.content:favoritesUrl::varchar(200)     as favoritesurl
    , a.content:firstName::varchar(200)        as firstname
    , a.content:groupsUrl::varchar(200)        as groupsurl
    , a.content:id::varchar(200)               as id
    , a.content:lastActiveAt::varchar(200)     as lastactiveat
    , a.content:lastName::varchar(200)         as lastname
    , a.content:learnerReportUrl::varchar(200) as learnerreporturl
    , a.content:role::varchar(200)             as role
    , a.content:url::varchar(200)              as url
    , _source_file                             as _source_file
    , _created_at                              as _created_at
    , _extracted_at                            as _extracted_at
    , case
        when _created_at = (select max(_created_at) from {{ source('reach_360', 'api_data') }} where _source_file = 'users')
            then 1
        else 0
    end                                        as is_head
from {{ source('reach_360', 'api_data') }} as a
where _source_file = 'users'
