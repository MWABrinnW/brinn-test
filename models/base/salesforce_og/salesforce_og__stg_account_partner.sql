select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , account_from_id::text                                                   as account_from_id
    , last_modified_by_id::text                                               as last_modified_by_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , is_primary::boolean                                                     as is_primary
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
    , account_to_id::text                                                     as account_to_id
    , opportunity_id::text                                                    as opportunity_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
    , role::text                                                              as role
    , reverse_partner_id::text                                                as reverse_partner_id
    , created_by_id::text                                                     as created_by_id
    , is_deleted::boolean                                                     as is_deleted
    , id::text                                                                as id
from {{ source('salesforce_og', 'account_partner') }}
