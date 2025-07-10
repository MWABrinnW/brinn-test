select
    'salesforce'                                                              as system_name
    , 'og'                                                                    as system_instance
    , concat(system_name , '__' , system_instance)                            as system_key
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz    as system_modstamp
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz   as _fivetran_synced
    , id::text                                                                as id
    , master_label::text                                                      as master_label
    , api_name::text                                                          as api_name
    , is_active::boolean                                                      as is_active
    , sort_order::number(18 , 2)                                              as sort_order
    , is_closed::boolean                                                      as is_closed
    , is_won::boolean                                                         as is_won
    , forecast_category::text                                                 as forecast_category
    , forecast_category_name::text                                            as forecast_category_name
    , default_probability::number(18 , 2)                                     as default_probability
    , description::text                                                       as description
    , created_by_id::text                                                     as created_by_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz       as created_date
    , last_modified_by_id::text                                               as last_modified_by_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz as last_modified_date
    , _fivetran_deleted::boolean                                              as _fivetran_deleted
from {{ source('salesforce_og', 'opportunity_stage') }}
