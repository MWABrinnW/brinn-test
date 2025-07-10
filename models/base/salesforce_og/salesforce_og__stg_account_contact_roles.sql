select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , last_modified_by_id::text                                               as last_modified_by_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
    , contact_id::text                                                        as contact_id
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
    , is_deleted::boolean                                                     as is_deleted
    , role::text                                                              as role
    , id::text                                                                as id
    , is_primary::boolean                                                     as is_primary
    , account_id::text                                                        as account_id
    , created_by_id::text                                                     as created_by_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
from {{ source('salesforce_og', 'account_contact_role') }}
