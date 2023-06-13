select a.content:authorUrl:: varchar(200)       as authorUrl
     , a.content:courseReportUrl:: varchar(200) as courseReportUrl
     , a.content:coverImageUrl:: varchar(200)   as coverImageUrl
     , a.content:id:: varchar(200)              as id
     , a.content:source:: varchar(200)          as source
     , a.content:title:: varchar(200)           as title
     , a.content:url:: varchar(200)             as url
     , _source_file                             as _source_file
     , _created_at                              as _created_at
     , _extracted_at                            as _extracted_at
     , case 
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file = 'courses') 
          then 1 else 0 
          end                                   as is_head
from {{ source('rise', 'api_data') }} a
where _source_file = 'courses'
