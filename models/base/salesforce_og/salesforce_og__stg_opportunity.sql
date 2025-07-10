select
    'salesforce'                                                                     as system_name
    , 'og'                                                                           as system_instance
    , concat(system_name , '__' , system_instance)                                   as system_key
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz              as created_date
    , fiscal_quarter::text                                                           as fiscal_quarter
    , lead_source_c::text                                                            as lead_source_c
    , is_deleted::boolean                                                            as is_deleted
    , pricebook_2_id::text                                                           as pricebook_2_id
    , stage_name::text                                                               as stage_name
    , last_close_date_changed_history_id::text                                       as last_close_date_changed_history_id
    , campaign_id::text                                                              as campaign_id
    , fin_serv_referred_by_user_c::text                                              as fin_serv_referred_by_user_c
    , expected_revenue::number(18 , 2)                                               as expected_revenue
    , discovery_completed_c::boolean                                                 as discovery_completed_c
    , lead_and_referral_c::text                                                      as lead_and_referral_c
    , lead_source::text                                                              as lead_source
    , fiscal::text                                                                   as fiscal
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz           as system_modstamp
    , last_activity_date::date                                                       as last_activity_date
    , client_manager_c::text                                                         as client_manager_c
    , created_by_id::text                                                            as created_by_id
    , compass_opportunity_id_c::text                                                 as compass_opportunity_id_c
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz        as last_modified_date
    , has_opportunity_line_item::boolean                                             as has_opportunity_line_item
    , client_start_date_c::date                                                      as client_start_date_c
    , zzprogram_source_c::text                                                       as zzprogram_source_c
    , fin_serv_referred_by_contact_c::text                                           as fin_serv_referred_by_contact_c
    , synced_quote_id::text                                                          as synced_quote_id
    , record_type_id::text                                                           as record_type_id
    , close_date::date                                                               as close_date
    , expected_revenue_c::number(18 , 2)                                             as expected_revenue_c
    , convert_timezone('America/Chicago' , intro_meeting_date_time_c)::timestamp_ntz as intro_meeting_date_time_c
    , fiscal_year::text                                                              as fiscal_year
    , convert_timezone('America/Chicago' , last_stage_change_date)::timestamp_ntz    as last_stage_change_date
    , probability::number(18 , 2)                                                    as probability
    , product_service_c::text                                                        as product_service_c
    , next_step::text                                                                as next_step
    , id::text                                                                       as id
    , closed_amount_c::number(18 , 2)                                                as closed_amount_c
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz          as _fivetran_synced
    , timeframe_to_invest_c::text                                                    as timeframe_to_invest_c
    , opportunity_ai_summary_c::text                                                 as opportunity_ai_summary_c
    , _fivetran_deleted::boolean                                                     as _fivetran_deleted
    , account_id::text                                                               as account_id
    , has_overdue_task::boolean                                                      as has_overdue_task
    , initial_referred_amount_c::number(18 , 2)                                      as initial_referred_amount_c
    , referral_branch_c::text                                                        as referral_branch_c
    , roi_analysis_completed_c::boolean                                              as roi_analysis_completed_c
    , contact_id::text                                                               as contact_id
    , owner_id::text                                                                 as owner_id
    , name::text                                                                     as name
    , activity_metric_id::text                                                       as activity_metric_id
    , description::text                                                              as description
    , last_modified_by_id::text                                                      as last_modified_by_id
    , convert_timezone('America/Chicago' , last_referenced_date)::timestamp_ntz      as last_referenced_date
    , convert_timezone('America/Chicago' , last_viewed_date)::timestamp_ntz          as last_viewed_date
    , is_closed::boolean                                                             as is_closed
    , budget_confirmed_c::boolean                                                    as budget_confirmed_c
    , lead_created_date_c::date                                                      as lead_created_date_c
    , amount::number(18 , 2)                                                         as amount
    , push_count::number(18 , 2)                                                     as push_count
    , loss_reason_c::text                                                            as loss_reason_c
    , convert_timezone('America/Chicago' , actual_close_date_c)::timestamp_ntz       as actual_close_date_c
    , final_closed_amount_c::number(18 , 2)                                          as final_closed_amount_c
    , is_private::boolean                                                            as is_private
    , forecast_category::text                                                        as forecast_category
    , is_won::boolean                                                                as is_won
    , type::text                                                                     as type
    , referral_source_c::text                                                        as referral_source_c
    , forecast_category_name::text                                                   as forecast_category_name
    , last_amount_changed_history_id::text                                           as last_amount_changed_history_id
    , has_open_activity::boolean                                                     as has_open_activity
from {{ source('salesforce_og', 'opportunity') }}
