select a.content:completedAt:: timestampLTZ      as completedAt
     , a.content:dueAt:: timestampLTZ            as dueAt
     , a.content:duration:: varchar(200)         as duration
     , a.content:email:: varchar(200)            as email
     , a.content:firstName:: varchar(200)        as firstName
     , a.content:lastActivity:: timestampLTZ     as lastActivity
     , a.content:lastName:: varchar(200)         as lastName
     , a.content:learnerReportUrl:: varchar(200) as learnerReportUrl
     , a.content:progress:: int                  as progress
     , a.content:quizScorePercent:: int          as quizScorePercent
     , a.content:status:: varchar(200)           as status
     , a.content:userDeleted:: varchar(200)      as userDeleted
     , a.content:userId:: varchar(200)           as userId
     , a.content:userUrl:: varchar(200)          as userUrl
     , split_part(_source_file, '/', 3)          as course_id
     , _source_file                              as _source_file
     , _created_at                               as _created_at
     , _extracted_at                             as _extracted_at
     , case
          when _created_at = (select max(_created_at) from {{ source('rise', 'api_data') }} where _source_file like 'reports/courses/%')
          then 1 else 0
          end                                    as is_head
from {{ source('rise', 'api_data') }} a
where _source_file like 'reports/courses/%'
