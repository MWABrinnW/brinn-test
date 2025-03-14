select
    compadvisorentryid::int      as comp_advisor_entry_id
    , recipientid::int           as recipient_id
    , compadvisorscheduleid::int as comp_advisor_schedule_id
    , compfactor::number(20 , 2) as comp_factor

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                            as _extracted_at
    , file_type::text            as file_type
    , _created_at::timestamp     as _created_at
    , _source_file::text         as _source_file
from {{ source('cambak', 'cbcompadvisorentry') }}
