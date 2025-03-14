select
    contactinfotypeid::int         as contact_info_typeid
    , isprimary::int               as is_primary
    , contactentitylinkid::int     as contact_entity_link_id
    , entityid::int                as entity_id
    , contactentityinfolinkid::int as contact_entity_infolink_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                              as _extracted_at
    , file_type::text              as file_type
    , _created_at::timestamp       as _created_at
    , _source_file::text           as _source_file
from {{ source('cambak', 'cbcontactentityinfolink') }}
