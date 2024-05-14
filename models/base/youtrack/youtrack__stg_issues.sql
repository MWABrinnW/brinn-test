select
    json:"id"::text(200)                                       as id
    , json:"idReadable"::text(200)                             as issue_id
    , json:"summary"::text(500)                                as summary
    , json:"description"::text                                 as description
    , json:"reporter":"fullName"::text(200)                    as reporter
    , to_timestamp_tz((json:"created"::int) / 1000)            as created_at
    , to_timestamp_tz((json:"updated"::int) / 1000)            as updated_at
    , to_timestamp_tz((json:"updated"::int) / 1000)            as resolved_at
    , json:"parent":"trimmedIssues"[0]:"idReadable"::text(200) as issue_id_parent
    , json:"isDraft"::boolean::int                             as is_draft
    , json:"project":"name"::text(200)                         as project
    , json:"commentsCount"::text(200)                          as comments_count
    , json:"customFields"::variant                             as custom_fields
    , _created_at                                              as _created_at
    , _updated_at                                              as _updated_at
    , _id                                                      as _id
from {{ source('youtrack', 'issues') }} as i
order by created_at desc