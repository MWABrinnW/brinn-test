select
    a.content:courseDeleted::boolean           as coursedeleted
    , a.content:courseId::varchar(200)         as courseid
    , a.content:courseReportUrl::varchar(200)  as coursereporturl
    , a.content:courseTitle::varchar(200)      as coursetitle
    , a.content:courseUrl::varchar(200)        as courseurl
    , a.content:duration::varchar(200)         as duration
    , a.content:email::varchar(200)            as email
    , a.content:firstName::varchar(200)        as firstname
    , a.content:lastName::varchar(200)         as lastname
    , a.content:learnerReportUrl::varchar(200) as learnerreporturl
    , a.content:numberOfLessonsCompleted::int  as numberoflessonscompleted
    , a.content:startedAt::timestampltz        as startedat
    , a.content:userDeleted::boolean           as userdeleted
    , a.content:userId::varchar(200)           as userid
    , a.content:userUrl::varchar(200)          as userurl
    , _source_file                             as _source_file
    , _created_at                              as _created_at
    , _extracted_at                            as _extracted_at
    , case
        when _created_at
            = (select max(_created_at) from {{ source('reach_360', 'api_data') }} where _source_file = 'reports/activity')
            then 1
        else 0
    end                                        as is_head
from {{ source('reach_360', 'api_data') }} as a
where _source_file = 'reports/activity'
