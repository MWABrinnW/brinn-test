select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
    , created_by_id::text                                                     as created_by_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , is_default::boolean                                                     as is_default
    , sort_order::number(18 , 2)                                              as sort_order
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
    , is_converted::boolean                                                   as is_converted
    , last_modified_by_id::text                                               as last_modified_by_id
    , master_label::text                                                      as master_label
    , api_name::text                                                          as api_name
    , id::text                                                                as id
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
from {{ source('salesforce_og', 'lead_status') }}
