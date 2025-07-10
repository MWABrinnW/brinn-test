select
    'salesforce'                                                            as system_name
    , 'og'                                                                  as system_instance
    , concat(system_name , '__' , system_instance)                          as system_key
    , data_type::text                                                       as data_type
    , old_value::text                                                       as old_value
    , field::text                                                           as field
    , _fivetran_deleted::boolean                                            as _fivetran_deleted
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz as _fivetran_synced
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz     as created_date
    , is_deleted::boolean                                                   as is_deleted
    , created_by_id::text                                                   as created_by_id
    , id::text                                                              as id
    , new_value::text                                                       as new_value
    , lead_id::text                                                         as lead_id
from {{ source('salesforce_og', 'lead_history') }}
