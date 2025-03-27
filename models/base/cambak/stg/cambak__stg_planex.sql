select
    clientid::integer                            as client_id
    , clientname::text                           as client_name
    , firmid::integer                            as firm_id
    , inceptiondate::text                        as inception_date
    , to_boolean(isclosed::text)::int            as is_closed
    , to_boolean(isexplicitclose::text)::int     as is_explicit_close
    , to_boolean(isprospect::text)::int          as is_prospect
    , notes::text                                as notes
    , planid::integer                            as plan_id
    , planname::text                             as plan_name
    , plansubtypeid::integer                     as plan_subtype_id
    , plantypeid::integer                        as plan_type_id
    , to_boolean(requiresproxyvoting::text)::int as requires_proxy_voting
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                            as _extracted_at
    , file_type::text                            as file_type
    , _created_at::timestamp                     as _created_at
    , _source_file::text                         as _source_file
from {{ source('cambak', 'planex') }}
