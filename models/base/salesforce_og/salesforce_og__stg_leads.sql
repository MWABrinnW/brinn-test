select
    'salesforce'                                                                               as system_name
    , 'og'                                                                                     as system_instance
    , concat(system_name , '__' , system_instance)                                             as system_key
    , is_priority_record::boolean                                                              as is_priority_record
    , speed_to_contact_days_c::float                                                           as speed_to_contact_days_c
    , state::text                                                                              as state
    , program_source_c::text                                                                   as program_source_c
    , country::text                                                                            as country
    , master_record_id::text                                                                   as master_record_id
    , phone::text                                                                              as phone
    , webinars_opt_out_c::boolean                                                              as webinars_opt_out_c
    , converted_opportunity_id::text                                                           as converted_opportunity_id
    , jigsaw_contact_id::text                                                                  as jigsaw_contact_id
    , description::text                                                                        as description
    , jigsaw::text                                                                             as jigsaw
    , referral_source_c::text                                                                  as referral_source_c
    , convert_timezone('America/Chicago' , email_bounced_date)::timestamp_ntz                  as email_bounced_date
    , street::text                                                                             as street
    , salutation::text                                                                         as salutation
    , name::text                                                                               as name
    , rating::text                                                                             as rating
    , annual_income_c::number(18 , 2)                                                          as annual_income_c
    , longitude::float                                                                         as longitude
    , referral_branch_c::text                                                                  as referral_branch_c
    , convert_timezone('America/Chicago' , first_call_date_time_c)::timestamp_ntz              as first_call_date_time_c
    , postal_code::text                                                                        as postal_code
    , company::text                                                                            as company
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz                     as system_modstamp
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz                        as created_date
    , middle_name::text                                                                        as middle_name
    , fin_serv_referred_by_contact_c::text                                                     as fin_serv_referred_by_contact_c
    , website::text                                                                            as website
    , annual_revenue::number(18 , 2)                                                           as annual_revenue
    , fin_serv_referred_by_user_c::text                                                        as fin_serv_referred_by_user_c
    , lead_source::text                                                                        as lead_source
    , converted_date::date                                                                     as converted_date
    , first_name::text                                                                         as first_name
    , suffix::text                                                                             as suffix
    , industry::text                                                                           as industry
    , product_service_c::text                                                                  as product_service_c
    , last_name::text                                                                          as last_name
    , individual_id::text                                                                      as individual_id
    , mobile_phone::text                                                                       as mobile_phone
    , record_type_id::text                                                                     as record_type_id
    , email::text                                                                              as email
    , aum_c::number(18 , 2)                                                                    as aum_c
    , notification_c::text                                                                     as notification_c
    , photo_url::text                                                                          as photo_url
    , initial_call_c::float                                                                    as initial_call_c
    , last_activity_date::date                                                                 as last_activity_date
    , activity_metric_id::text                                                                 as activity_metric_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz                  as last_modified_date
    , date_of_birth_c::date                                                                    as date_of_birth_c
    , speed_to_contact_hours_c::float                                                          as speed_to_contact_hours_c
    , number_of_employees::number(18 , 2)                                                      as number_of_employees
    , convert_timezone('America/Chicago' , last_viewed_date)::timestamp_ntz                    as last_viewed_date
    , convert_timezone('America/Chicago' , first_email_date_time)::timestamp_ntz               as first_email_date_time
    , is_converted::boolean                                                                    as is_converted
    , created_by_id::text                                                                      as created_by_id
    , timeframe_to_invest_c::date                                                              as timeframe_to_invest_c
    , last_modified_by_id::text                                                                as last_modified_by_id
    , convert_timezone('America/Chicago' , first_call_date_time)::timestamp_ntz                as first_call_date_time
    , net_worth_c::number(18 , 2)                                                              as net_worth_c
    , title::text                                                                              as title
    , preferred_contact_method_c::text                                                         as preferred_contact_method_c
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz                    as _fivetran_synced
    , newsletter_opt_out_c::boolean                                                            as newsletter_opt_out_c
    , is_pre_qualified_c::boolean                                                              as is_pre_qualified_c
    , id::text                                                                                 as id
    , convert_timezone('America/Chicago' , last_referenced_date)::timestamp_ntz                as last_referenced_date
    , lead_source_c::text                                                                      as lead_source_c
    , converted_account_id::text                                                               as converted_account_id
    , latitude::float                                                                          as latitude
    , is_deleted::boolean                                                                      as is_deleted
    , nickname_c::text                                                                         as nickname_c
    , geocode_accuracy::text                                                                   as geocode_accuracy
    , lost_reason_c::text                                                                      as lost_reason_c
    , owner_id::text                                                                           as owner_id
    , city::text                                                                               as city
    , fax::text                                                                                as fax
    , financial_updates_opt_out_c::boolean                                                     as financial_updates_opt_out_c
    , convert_timezone('America/Chicago' , last_status_change_c)::timestamp_ntz                as last_status_change_c
    , convert_timezone('America/Chicago' , first_call_date_time_scheduled_on_c)::timestamp_ntz
        as first_call_date_time_scheduled_on_c
    , is_unread_by_owner::boolean                                                              as is_unread_by_owner
    , email_bounced_reason::text                                                               as email_bounced_reason
    , _fivetran_deleted::boolean                                                               as _fivetran_deleted
    , agent_opt_out_c::boolean                                                                 as agent_opt_out_c
    , status::text                                                                             as status
    , converted_contact_id::text                                                               as converted_contact_id
from {{ source('salesforce_og', 'lead') }}
