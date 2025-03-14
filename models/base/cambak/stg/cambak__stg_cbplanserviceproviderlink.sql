select
    roleid::int                               as role_id
    , to_boolean(isdirectrelation::text)::int as is_direct_relation
    , cbplanserviceproviderlinkid::int        as cb_plan_service_provider_link_id
    , serviceprovidertypeid::int              as service_provider_typeid
    , notes::text                             as notes
    , firmid::int                             as firm_id
    , serviceproviderid::int                  as service_provider_id
    , planid::int                             as plan_id
    , locationid::int                         as location_id

    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                         as _extracted_at
    , file_type::text                         as file_type
    , _created_at::timestamp                  as _created_at
    , _source_file::text                      as _source_file
from {{ source('cambak', 'cbplanserviceproviderlink') }}
