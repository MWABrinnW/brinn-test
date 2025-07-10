select
    'salesforce'                                                            as system_name
    , 'og'                                                                  as system_instance
    , concat(system_name , '__' , system_instance)                          as system_key
    , forecast_category::text                                               as forecast_category
    , _fivetran_deleted::boolean                                            as _fivetran_deleted
    , prev_amount::number(18 , 2)                                           as prev_amount
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz  as system_modstamp
    , probability::float                                                    as probability
    , stage_name::text                                                      as stage_name
    , expected_revenue::number(18 , 2)                                      as expected_revenue
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz as _fivetran_synced
    , is_deleted::boolean                                                   as is_deleted
    , amount::number(18 , 2)                                                as amount
    , prev_close_date::date                                                 as prev_close_date
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz     as created_date
    , id::text                                                              as id
    , opportunity_id::text                                                  as opportunity_id
    , created_by_id::text                                                   as created_by_id
    , close_date::date                                                      as close_date
from {{ source('salesforce_og', 'opportunity_history') }}
