{% set src = source('emoney_mwa', 'tasks') %}
select
    try_to_boolean(_data:"completed"::text)::int as completed
    , _data:"text"::text(200)                    as text
    , _data:"subject"::text(200)                 as subject
    , _data:"clientid"::text(200)                as client_id
    , _data:"assignedto"::text(200)              as assigned_to
    , _data:"createddate"::text(200)             as created_date
    , _data:"duedate"::text(200)                 as due_date
    , _data:"lasteditedby"::text(200)            as last_edited_by
    , _data:"reminderdate"::text(200)            as reminder_date
    , _data:"requestedby"::text(200)             as requested_by
    , _data:"taskid"::text(200)                  as task_id

    , effective_date::date                       as effective_date
    , _created_at::timestamp                     as _created_at
    , _source_file::text(200)                    as _source_file
    , {{ col_is_head(reference=src) }}
from {{ src }}
