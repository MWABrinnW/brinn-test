select
    a.content:id::varchar(200)             as id
    , a.content:managersUrl::varchar(200)  as managersurl
    , a.content:membersUrl::varchar(200)   as membersurl
    , a.content:name::varchar(200)         as name
    , a.content:reportersUrl::varchar(200) as reportersurl
    , a.content:url::varchar(200)          as url
    , _source_file                         as _source_file
    , _created_at                          as _created_at
    , _extracted_at                        as _extracted_at
    , case
        when _created_at = (select max(_created_at) from {{ source('reach_360', 'api_data') }} where _source_file = 'groups')
            then 1
        else 0
    end                                    as is_head
from {{ source('reach_360', 'api_data') }} as a
where _source_file = 'groups'
