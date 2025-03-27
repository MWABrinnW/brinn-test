select
    contactdisplayname::text   as contact_display_name
    , contactemails::text      as contact_emails
    , contactid::integer       as contact_id
    , contactphonenumber::text as contact_phone_number
    , firmid::integer          as firmid
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                          as _extracted_at
    , file_type::text          as file_type
    , _created_at::timestamp   as _created_at
    , _source_file::text       as _source_file
from {{ source('cambak', 'matchingcontacts') }}
