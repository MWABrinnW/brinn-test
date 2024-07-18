select
    a.content:authorUrl::varchar(200)         as authorurl
    , a.content:contentType::varchar(200)     as contenttype
    , a.content:courseReportUrl::varchar(200) as coursereporturl
    , a.content:coverImageUrl::varchar(200)   as coverimageurl
    , a.content:id::varchar(200)              as id
    , a.content:title::varchar(200)           as title
    , a.content:url::varchar(200)             as url
    , _source_file                            as _source_file
    , _created_at                             as _created_at
    , _extracted_at                           as _extracted_at
    , case
        when _created_at = (select max(_created_at) from {{ source('reach_360', 'api_data') }} where _source_file = 'courses')
            then 1
        else 0
    end                                       as is_head
from {{ source('reach_360', 'api_data') }} as a
where _source_file = 'courses'
