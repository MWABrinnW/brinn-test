select
    statementid::int                                                     as statement_id
    , description::text                                                  as description
    , to_timestamp_ntz(enddate::text , 'MM/DD/YYYY HH12:MI:SS AM')       as end_date
    , to_timestamp_ntz(created::text , 'MM/DD/YYYY HH12:MI:SS AM')::text as created
    , accountid::int                                                     as account_id
    , firmid::int                                                        as firm_id
    , imagefileid::int                                                   as image_file_id
    , custodialrelationshipid::int                                       as custodial_relationship_id
    , createdbyid::int                                                   as created_by_id
    , to_boolean(isdeleted::text)::int                                   as is_deleted

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                    as _extracted_at
    , file_type::text                                                    as file_type
    , _created_at::timestamp                                             as _created_at
    , _source_file::text                                                 as _source_file
from {{ source('cambak', 'cbstatement') }}
