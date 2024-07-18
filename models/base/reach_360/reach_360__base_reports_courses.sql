select
    a.content:completedAt::TIMESTAMPLTZ        as completedat
    , a.content:dueAt::TIMESTAMPLTZ            as dueat
    , a.content:duration::VARCHAR(200)         as duration
    , a.content:email::VARCHAR(200)            as email
    , a.content:firstName::VARCHAR(200)        as firstname
    , a.content:lastActivity::TIMESTAMPLTZ     as lastactivity
    , a.content:lastName::VARCHAR(200)         as lastname
    , a.content:learnerReportUrl::VARCHAR(200) as learnerreporturl
    , a.content:progress::INT                  as progress
    , a.content:quizScorePercent::INT          as quizscorepercent
    , a.content:status::VARCHAR(200)           as status
    , a.content:userDeleted::VARCHAR(200)      as userdeleted
    , a.content:userId::VARCHAR(200)           as userid
    , a.content:userUrl::VARCHAR(200)          as userurl
    , split_part(_source_file , '/' , 3)       as course_id
    , _source_file                             as _source_file
    , _created_at                              as _created_at
    , _extracted_at                            as _extracted_at
    , case
        when _created_at
            = (select max(_created_at) from {{ source('reach_360', 'api_data') }} where _source_file like 'reports/courses/%')
            then 1
        else 0
    end                                        as is_head
from {{ source('reach_360', 'api_data') }} as a
where _source_file like 'reports/courses/%'
