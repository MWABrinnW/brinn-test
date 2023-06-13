select a.content:courseAvailable:: boolean       as courseAvailable
     , a.content:courseDeleted:: boolean         as courseDeleted
     , a.content:courseId:: varchar(200)         as courseId
     , a.content:courseReportUrl:: varchar(200)  as courseReportUrl
     , a.content:courseTitle:: varchar(200)      as courseTitle
     , a.content:courseUrl:: varchar(200)        as courseUrl
     , a.content:duration:: varchar(200)         as duration
     , a.content:email:: varchar(200)            as email
     , a.content:firstName:: varchar(200)        as firstName
     , a.content:lastName:: varchar(200)         as lastName
     , a.content:learnerReportUrl:: varchar(200) as learnerReportUrl
     , a.content:numberOfLessonsCompleted:: int  as numberOfLessonsCompleted
     , a.content:startedAt:: timestampLTZ        as startedAt
     , a.content:userDeleted:: boolean           as userDeleted
     , a.content:userId:: varchar(200)           as userId
     , a.content:userUrl:: varchar(200)          as userUrl
     , _source_file                              as _source_file
     , _created_at                               as _created_at
     , _extracted_at                             as _extracted_at
     , case 
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file = 'reports/activity') 
          then 1 else 0 
          end                                    as is_head
from {{ source('rise', 'api_data') }} a
where _source_file = 'reports/activity'
