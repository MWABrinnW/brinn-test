select
    clientid::integer                 as client_id
    , firmid::integer                 as firm_id
    , firstname::text                 as first_name
    , to_boolean(isactive::text)::int as is_active
    , lastname::text                  as last_name
    , plandetails::text               as plan_details
    , planroledetails::text           as plan_role_details
    , roledetails::text               as role_details
    , userdisplayname::text           as user_display_name
    , userid::integer                 as user_id
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                 as _extracted_at
    , file_type::text                 as file_type
    , _created_at::timestamp          as _created_at
    , _source_file::text              as _source_file
from {{ source('cambak', 'clientteammembersdetails') }}
