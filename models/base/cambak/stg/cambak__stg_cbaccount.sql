select
    accountid::int                           as account_id
    , accountname::text                      as account_name
    , planid::int                            as plan_id
    , firmid::int                            as firm_id
    , clientid::int                          as client_id
    , to_boolean(isexplicitclose::text)::int as is_explicit_close
    , to_boolean(isclosed::text)::int        as is_closed
    , inceptiondate::timestamp_ntz           as inception_date
    , notes::text                            as notes

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                        as _extracted_at
    , file_type::text                        as file_type
    , _created_at::timestamp                 as _created_at
    , _source_file::text                     as _source_file
from {{ source('cambak', 'cbaccount') }}
