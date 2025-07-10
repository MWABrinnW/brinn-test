select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , is_direct::boolean                                                      as is_direct
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , last_modified_by_id::text                                               as last_modified_by_id
    , contact_id::text                                                        as contact_id
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
    , is_deleted::boolean                                                     as is_deleted
    , account_id::text                                                        as account_id
    , is_active::boolean                                                      as is_active
    , id::text                                                                as id
    , fin_serv_primary_group_c::boolean                                       as fin_serv_primary_group_c
    , created_by_id::text                                                     as created_by_id
    , fin_serv_include_in_group_c::boolean                                    as fin_serv_include_in_group_c
    , end_date::date                                                          as end_date
    , start_date::date                                                        as start_date
    , fin_serv_primary_c::boolean                                             as fin_serv_primary_c
    , compass_account_id_c::text                                              as compass_account_id_c
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
    , fin_serv_rollups_c::text                                                as fin_serv_rollups_c
    , compass_acr_id_c::text                                                  as compass_acr_id_c
    , compass_contact_id_c::text                                              as compass_contact_id_c
    , roles::text                                                             as roles
from {{ source('salesforce_og', 'account_contact_relation') }}
