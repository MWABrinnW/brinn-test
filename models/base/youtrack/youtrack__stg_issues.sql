select
    json:"id"::text(200)                                       as id
    , json:"idReadable"::text(200)                             as issue_id
    , json:"project":name::text                                as project_name
    , json:"project":id::text                                  as project_id
    , json:"name":name::text                                   as project_description
    , json:"summary"::text(500)                                as summary
    , json:"description"::text                                 as description
    , json:"reporter":"fullName"::text(200)                    as reporter
    , to_timestamp_tz((json:"created"::int) / 1000)            as created_at
    , to_timestamp_tz((json:"updated"::int) / 1000)            as updated_at
    , json:"updater":"fullName"::text                          as updated_by
    , to_timestamp_tz((json:"resolved"::int) / 1000)           as resolved_at
    , json:"parent":"trimmedIssues"[0]:"idReadable"::text(200) as parent_issue_id
    , json:"project":"name"::text(200)                         as project
    , json:"commentsCount"::text(200)                          as comments_count
    , json:"links"::variant                                    as links
    , json:"subtasks"::variant                                 as subtasks
    , json:"customFields"::variant                             as custom_fields
    , json:"tags"::variant                                     as tags
    , json:"visibility"::variant                               as visibility
    , json:"watchers"::variant                                 as watchers
    , json:"wikifiedDescription"::text                         as wikified_description
    , json:"isDraft"::boolean::int                             as is_draft
    , json:"comments"::variant                                 as comments
    , _created_at                                              as _created_at
    , _updated_at                                              as _updated_at
    , _id                                                      as _id
from {{ source('youtrack', 'issues') }}
order by created_at desc
--
