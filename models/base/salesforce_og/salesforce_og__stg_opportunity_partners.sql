select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , reverse_partner_id::text                                                as reverse_partner_id
    , created_by_id::text                                                     as created_by_id
    , opportunity_id::text                                                    as opportunity_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
    , is_primary::boolean                                                     as is_primary
    , role::text                                                              as role
    , account_to_id::text                                                     as account_to_id
    , id::text                                                                as id
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
    , is_deleted::boolean                                                     as is_deleted
    , last_modified_by_id::text                                               as last_modified_by_id
from {{ source('salesforce_og', 'opportunity_partner') }}
