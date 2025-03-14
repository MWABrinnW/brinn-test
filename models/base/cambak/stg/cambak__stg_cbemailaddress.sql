select
    emailaddressid::int                 as email_address_id
    , firmid::int                       as firm_id
    , emailaddress::text                as email_address
    , emailaddressnote::text            as email_address_note
    , ownerid::int                      as owner_id
    , ownertypeid::int                  as owner_type_id
    , to_boolean(ispersonal::text)::int as is_personal

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                   as _extracted_at
    , file_type::text                   as file_type
    , _created_at::timestamp            as _created_at
    , _source_file::text                as _source_file
from {{ source('cambak', 'cbemailaddress') }}
