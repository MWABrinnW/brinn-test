select
    to_boolean(isclosed::text)::int          as is_closed
    , planname::text                         as plan_name
    , accountid::int                         as account_id
    , clientname::text                       as client_name
    , notes::text                            as notes
    , clientid::int                          as client_id
    , accountname::text                      as account_name
    , firmid::int                            as firm_id
    , to_boolean(isexplicitclose::text)::int as is_explicit_close
    , inceptiondate::timestamp_ntz           as inception_date
    , planid::int                            as plan_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                        as _extracted_at
    , file_type::text                        as file_type
    , _created_at::timestamp                 as _created_at
    , _source_file::text                     as _source_file
from {{ source('cambak', 'accountex') }}
