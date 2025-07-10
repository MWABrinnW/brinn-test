select
    'salesforce'                                                                as system_name
    , 'og'                                                                      as system_instance
    , concat(system_name , '__' , system_instance)                              as system_key
    , is_deleted::boolean                                                       as is_deleted
    , convert_timezone('America/Chicago' , last_referenced_date)::timestamp_ntz as last_referenced_date
    , status::text                                                              as status
    , last_activity_date::date                                                  as last_activity_date
    , amount_all_opportunities::number(18 , 2)                                  as amount_all_opportunities
    , created_by_id::text                                                       as created_by_id
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz      as system_modstamp
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz     as _fivetran_synced
    , number_of_leads::number(18 , 2)                                           as number_of_leads
    , number_of_converted_leads::number(18 , 2)                                 as number_of_converted_leads
    , number_of_contacts::number(18 , 2)                                        as number_of_contacts
    , is_active::boolean                                                        as is_active
    , number_of_won_opportunities::number(18 , 2)                               as number_of_won_opportunities
    , amount_won_opportunities::number(18 , 2)                                  as amount_won_opportunities
    , actual_cost::number(18 , 2)                                               as actual_cost
    , last_modified_by_id::text                                                 as last_modified_by_id
    , number_of_opportunities::number(18 , 2)                                   as number_of_opportunities
    , owner_id::text                                                            as owner_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz   as last_modified_date
    , convert_timezone('America/Chicago' , last_viewed_date)::timestamp_ntz     as last_viewed_date
    , name::text                                                                as name
    , budgeted_cost::number(18 , 2)                                             as budgeted_cost
    , _fivetran_deleted::boolean                                                as _fivetran_deleted
    , type::text                                                                as type
    , expected_revenue::number(18 , 2)                                          as expected_revenue
    , id::text                                                                  as id
    , number_of_responses::number(18 , 2)                                       as number_of_responses
    , number_sent::float                                                        as number_sent
    , expected_response::float                                                  as expected_response
    , start_date::date                                                          as start_date
    , campaign_member_record_type_id::text                                      as campaign_member_record_type_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz         as created_date
    , parent_id::text                                                           as parent_id
    , description::text                                                         as description
    , end_date::date                                                            as end_date
from {{ source('salesforce_og', 'campaign') }}
