select
    'salesforce'                                                            as system_name
    , 'og'                                                                  as system_instance
    , concat(system_name , '__' , system_instance)                          as system_key
    , new_value::text                                                       as new_value
    , id::text                                                              as id
    , is_deleted::boolean                                                   as is_deleted
    , data_type::text                                                       as data_type
    , created_by_id::text                                                   as created_by_id
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz as _fivetran_synced
    , _fivetran_deleted::boolean                                            as _fivetran_deleted
    , field::text                                                           as field
    , campaign_id::text                                                     as campaign_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz     as created_date
    , old_value::text                                                       as old_value
from {{ source('salesforce_og', 'campaign_history') }}
