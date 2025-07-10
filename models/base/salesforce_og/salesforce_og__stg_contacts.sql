select
    'salesforce'                                                                  as system_name
    , 'og'                                                                        as system_instance
    , concat(system_name , '__' , system_instance)                                as system_key
    , data_migration_helper_c::boolean                                            as data_migration_helper_c
    , last_name::text                                                             as last_name
    , other_country::text                                                         as other_country
    , email::text                                                                 as email
    , convert_timezone('America/Chicago' , last_viewed_date)::timestamp_ntz       as last_viewed_date
    , master_record_id::text                                                      as master_record_id
    , net_worth_c::number(18 , 2)                                                 as net_worth_c
    , first_name::text                                                            as first_name
    , salutation::text                                                            as salutation
    , convert_timezone('America/Chicago' , first_email_date_time)::timestamp_ntz  as first_email_date_time
    , account_id::text                                                            as account_id
    , email_bounced_reason::text                                                  as email_bounced_reason
    , middle_name::text                                                           as middle_name
    , convert_timezone('America/Chicago' , first_call_date_time)::timestamp_ntz   as first_call_date_time
    , title::text                                                                 as title
    , home_phone::text                                                            as home_phone
    , contact_source::text                                                        as contact_source
    , jigsaw::text                                                                as jigsaw
    , mailing_state::text                                                         as mailing_state
    , mailing_city::text                                                          as mailing_city
    , owner_id::text                                                              as owner_id
    , business_address_state_c::text                                              as business_address_state_c
    , agent_opt_out_c::boolean                                                    as agent_opt_out_c
    , mobile_phone::text                                                          as mobile_phone
    , department::text                                                            as department
    , roles_c::text                                                               as roles_c
    , other_phone::text                                                           as other_phone
    , other_postal_code::text                                                     as other_postal_code
    , notification_id_c::text                                                     as notification_id_c
    , birthdate::date                                                             as birthdate
    , convert_timezone('America/Chicago' , last_curequest_date)::timestamp_ntz    as last_curequest_date
    , referral_branch_c::text                                                     as referral_branch_c
    , potential_aum_c::number(18 , 2)                                             as potential_aum_c
    , referral_employee_c::boolean                                                as referral_employee_c
    , date_of_birth_c::date                                                       as date_of_birth_c
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz       as _fivetran_synced
    , business_address_street_c::text                                             as business_address_street_c
    , assistant_name::text                                                        as assistant_name
    , mailing_street::text                                                        as mailing_street
    , other_longitude::float                                                      as other_longitude
    , suffix::text                                                                as suffix
    , other_street::text                                                          as other_street
    , mailing_longitude::float                                                    as mailing_longitude
    , is_deleted::boolean                                                         as is_deleted
    , marketing_cloud_undeliverable_c::boolean                                    as marketing_cloud_undeliverable_c
    , mailing_country::text                                                       as mailing_country
    , activity_metric_id::text                                                    as activity_metric_id
    , business_address_postal_code_c::text                                        as business_address_postal_code_c
    , other_state::text                                                           as other_state
    , business_address_city_c::text                                               as business_address_city_c
    , are_you_a_c::text                                                           as are_you_a_c
    , annual_income_c::number(18 , 2)                                             as annual_income_c
    , other_latitude::float                                                       as other_latitude
    , name::text                                                                  as name
    , lead_source::text                                                           as lead_source
    , business_phone_c::text                                                      as business_phone_c
    , financial_updates_opt_out_c::boolean                                        as financial_updates_opt_out_c
    , individual_id::text                                                         as individual_id
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz     as last_modified_date
    , convert_timezone('America/Chicago' , first_call_date_time_c)::timestamp_ntz as first_call_date_time_c
    , is_priority_record::boolean                                                 as is_priority_record
    , lead_source_c::text                                                         as lead_source_c
    , compass_user_id_c::text                                                     as compass_user_id_c
    , compass_contact_id_c::text                                                  as compass_contact_id_c
    , newsletter_opt_out_c::boolean                                               as newsletter_opt_out_c
    , product_service_c::text                                                     as product_service_c
    , referral_branch_employee_of_c::text                                         as referral_branch_employee_of_c
    , record_type_id::text                                                        as record_type_id
    , retired_c::boolean                                                          as retired_c
    , convert_timezone('America/Chicago' , last_referenced_date)::timestamp_ntz   as last_referenced_date
    , _fivetran_deleted::boolean                                                  as _fivetran_deleted
    , created_by_id::text                                                         as created_by_id
    , is_email_bounced::boolean                                                   as is_email_bounced
    , convert_timezone('America/Chicago' , email_bounced_date)::timestamp_ntz     as email_bounced_date
    , mailing_latitude::float                                                     as mailing_latitude
    , dd_rep_crd_c::text                                                          as dd_rep_crd_c
    , speed_to_contact_days_c::float                                              as speed_to_contact_days_c
    , preferred_email_c::text                                                     as preferred_email_c
    , webinars_opt_out_c::boolean                                                 as webinars_opt_out_c
    , last_modified_by_id::text                                                   as last_modified_by_id
    , phone::text                                                                 as phone
    , description::text                                                           as description
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz        as system_modstamp
    , jigsaw_contact_id::text                                                     as jigsaw_contact_id
    , dd_firm_crd_branch_id_c::text                                               as dd_firm_crd_branch_id_c
    , client_propsect_ai_summary_c::text                                          as client_propsect_ai_summary_c
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz           as created_date
    , last_activity_date::date                                                    as last_activity_date
    , speed_to_contact_hours_c::float                                             as speed_to_contact_hours_c
    , zzprogram_source_c::text                                                    as zzprogram_source_c
    , reports_to_id::text                                                         as reports_to_id
    , assistant_phone::text                                                       as assistant_phone
    , fax::text                                                                   as fax
    , preferred_contact_method_c::text                                            as preferred_contact_method_c
    , id::text                                                                    as id
    , business_email_c::text                                                      as business_email_c
    , is_person_account::boolean                                                  as is_person_account
    , referral_source_c::text                                                     as referral_source_c
    , mailing_postal_code::text                                                   as mailing_postal_code
    , other_geocode_accuracy::text                                                as other_geocode_accuracy
    , other_city::text                                                            as other_city
    , convert_timezone('America/Chicago' , last_cuupdate_date)::timestamp_ntz     as last_cuupdate_date
    , initial_call_c::float                                                       as initial_call_c
    , photo_url::text                                                             as photo_url
    , mailing_geocode_accuracy::text                                              as mailing_geocode_accuracy
from {{ source('salesforce_og', 'contact') }}
