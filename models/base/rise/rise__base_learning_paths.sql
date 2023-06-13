select a.content:coursesReportUrl:: varchar(200)  as coursesReportUrl
     , a.content:coursesUrl:: varchar(200)        as coursesUrl
     , a.content:description:: varchar(10000)       as description
     , a.content:id:: varchar(200)                as id
     , a.content:learnersReportUrl:: varchar(200) as learnersReportUrl
     , a.content:title:: varchar(200)             as title
     , a.content:url:: varchar(200)               as url
     , _source_file                               as _source_file
     , _created_at                                as _created_at
     , _extracted_at                              as _extracted_at
     , case 
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file = 'learning-paths') 
          then 1 else 0 
          end                                     as is_head
from {{ source('rise', 'api_data') }} a
where _source_file = 'learning-paths'
