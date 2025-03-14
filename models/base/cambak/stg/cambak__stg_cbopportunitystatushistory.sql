select
    opportunitystatushistoryid::int                                          as opportunity_status_history_id
    , opportunityid::int                                                     as opportunity_id
    , to_timestamp_ntz(statushistorydate::text , 'MM/DD/YYYY HH12:MI:SS AM') as status_history_date-- needs date
    , statusid::int                                                          as status_id
    , statusnote::text                                                       as status_note
    , createduserid::int                                                     as created_user_id
    , to_timestamp_ntz(createddate::text , 'MM/DD/YYYY HH12:MI:SS AM')       as created_date-- needs date
    , to_boolean(isdeleted::text)::int                                       as is_deleted
    , deleteduserid::int                                                     as deleted_userid
    , to_timestamp_ntz(deletedate::text , 'MM/DD/YYYY HH12:MI:SS AM')        as delete_date-- needs date

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                                        as _extracted_at
    , file_type::text                                                        as file_type
    , _created_at::timestamp                                                 as _created_at
    , _source_file::text                                                     as _source_file
from {{ source('cambak', 'cbopportunitystatushistory') }}
