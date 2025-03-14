select
    contactid::int                            as contact_id
    , firmid::int                             as firm_id
    , prefixid::int                           as prefix_id
    , givenname::text                         as given_name
    , surname::text                           as surname
    , suffixid::int                           as suffix_id
    , primaryphoneid::int                     as primary_phone_id
    , primaryemailid::int                     as primary_email_id
    , primaryphysicaladdressid::int           as primary_physical_address_id
    , to_boolean(isdeleted::text)::int        as is_deleted
    , middlename::text                        as middle_name
    , contactuniqueidentifier::text           as contact_unique_identifier
    , to_boolean(willingreference::text)::int as willing_reference

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                         as _extracted_at
    , file_type::text                         as file_type
    , _created_at::timestamp                  as _created_at
    , _source_file::text                      as _source_file
from {{ source('cambak', 'cbcontact') }}
