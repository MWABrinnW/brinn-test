select
    accounts::text                                              as accounts
    , address1::text                                            as address_1
    , city::text                                                as city
    , clientid::integer                                         as client_id
    , clientname::text                                          as client_name
    , firmid::integer                                           as firm_id
    , to_boolean(hasplanserviceproviderrelationship::text)::int as has_plan_service_provider_relationship
    , id::text                                                  as id
    , to_boolean(isdirect::text)::int                           as is_direct
    , locationid::text                                          as location_id
    , locationname::text                                        as location_name
    , locationtype::text                                        as location_type
    , note::text                                                as note
    , planid::integer                                           as plan_id
    , planname::text                                            as plan_name
    , postalcode::text                                          as postal_code
    , providerid::text                                          as provider_id
    , providername::text                                        as provider_name
    , providertypeid::integer                                   as provider_type_id
    , role::text                                                as role
    , state::text                                               as state
    , to_timestamp_ntz(
        regexp_substr(
            _source_file , '(\\d{4}-\\d{2}-\\d{2}__\\d{2}_\\d{2}_\\d{2})'
        )
        , 'YYYY-MM-DD__HH_MI_SS'
    )                                                           as _extracted_at
    , file_type::text                                           as file_type
    , _created_at::timestamp                                    as _created_at
    , _source_file::text                                        as _source_file
from {{ source('cambak', 'planserviceproviderrelationship') }}
