select
    contactid::int             as contact_id
    , entitylocationid::int    as entity_location_id
    , contactentitylinkid::int as contact_entity_link_id
    , firmid::int              as firm_id
    , entityid::int            as entity_id
    , entitytypeid::int        as entity_type_id
    , rolename::text           as role_name
    , notes::text              as notes
    , roleid::int              as role_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                          as _extracted_at
    , file_type::text          as file_type
    , _created_at::timestamp   as _created_at
    , _source_file::text       as _source_file
from {{ source('cambak', 'cbcontactentitylink') }}
