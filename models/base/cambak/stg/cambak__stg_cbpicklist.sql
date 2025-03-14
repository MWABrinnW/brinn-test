select
    to_boolean(ishiddeninrelatedattribute::text)::int as is_hidden_in_related_attribute
    , picklistid::int                                 as picklist_id
    , picklistname::text                              as picklist_name
    , masterlistid::int                               as master_list_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                 as _extracted_at
    , file_type::text                                 as file_type
    , _created_at::timestamp                          as _created_at
    , _source_file::text                              as _source_file
from {{ source('cambak', 'cbpicklist') }}
