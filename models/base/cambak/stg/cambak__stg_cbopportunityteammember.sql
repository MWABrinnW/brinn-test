select
    roleid::int                    as role_id
    , rolenote::text               as role_note
    , opportunityteammemberid::int as opportunity_team_member_id
    , opportunityid::int           as opportunity_id
    , firmid::int                  as firm_id
    , userid::int                  as userid

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                              as _extracted_at
    , file_type::text              as file_type
    , _created_at::timestamp       as _created_at
    , _source_file::text           as _source_file
from {{ source('cambak', 'cbopportunityteammember') }}
