select
    'salesforce'                                                                               as system_name
    , 'og'                                                                                     as system_instance
    , concat(system_name , '__' , system_instance)                                             as system_key
    , billing_longitude::float                                                                 as billing_longitude
    , convert_timezone('America/Chicago' , person_email_bounced_date)::timestamp_ntz           as person_email_bounced_date
    , person_mailing_street::text                                                              as person_mailing_street
    , ticker_symbol::text                                                                      as ticker_symbol
    , business_phone_pc::text                                                                  as business_phone_pc
    , shipping_city::text                                                                      as shipping_city
    , person_email::text                                                                       as person_email
    , agent_opt_out_pc::boolean                                                                as agent_opt_out_pc
    , net_worth_pc::number(18 , 2)                                                             as net_worth_pc
    , billing_latitude::float                                                                  as billing_latitude
    , roles_pc::text                                                                           as roles_pc
    , compass_user_id_pc::text                                                                 as compass_user_id_pc
    , is_deleted::boolean                                                                      as is_deleted
    , photo_url::text                                                                          as photo_url
    , person_title::text                                                                       as person_title
    , billing_country::text                                                                    as billing_country
    , record_type_id::text                                                                     as record_type_id
    , person_mailing_geocode_accuracy::text                                                    as person_mailing_geocode_accuracy
    , phone::text                                                                              as phone
    , jigsaw::text                                                                             as jigsaw
    , convert_timezone('America/Chicago' , first_call_date_time_scheduled_on_c)::timestamp_ntz
        as first_call_date_time_scheduled_on_c
    , person_other_state::text                                                                 as person_other_state
    , business_address_city_pc::text                                                           as business_address_city_pc
    , person_home_phone::text                                                                  as person_home_phone
    , billing_street::text                                                                     as billing_street
    , zzprogram_source_pc::text                                                                as zzprogram_source_pc
    , date_of_birth_pc::date                                                                   as date_of_birth_pc
    , business_address_street_pc::text                                                         as business_address_street_pc
    , created_by_id::text                                                                      as created_by_id
    , preferred_email_pc::text                                                                 as preferred_email_pc
    , salutation::text                                                                         as salutation
    , person_lead_source::text                                                                 as person_lead_source
    , referral_branch_employee_of_pc::text                                                     as referral_branch_employee_of_pc
    , website::text                                                                            as website
    , person_assistant_name::text                                                              as person_assistant_name
    , retired_pc::boolean                                                                      as retired_pc
    , product_service_pc::text                                                                 as product_service_pc
    , site::text                                                                               as site
    , _fivetran_deleted::boolean                                                               as _fivetran_deleted
    , person_other_latitude::float                                                             as person_other_latitude
    , billing_postal_code::text                                                                as billing_postal_code
    , annual_revenue::number(18 , 2)                                                           as annual_revenue
    , person_department::text                                                                  as person_department
    , shipping_latitude::float                                                                 as shipping_latitude
    , financial_updates_opt_out_pc::boolean                                                    as financial_updates_opt_out_pc
    , id::text                                                                                 as id
    , annual_income_pc::number(18 , 2)                                                         as annual_income_pc
    , source_system_identifier::text                                                           as source_system_identifier
    , shipping_postal_code::text                                                               as shipping_postal_code
    , last_name::text                                                                          as last_name
    , person_email_bounced_reason::text                                                        as person_email_bounced_reason
    , master_record_id::text                                                                   as master_record_id
    , parent_id::text                                                                          as parent_id
    , compass_client_id_c::text                                                                as compass_client_id_c
    , first_name::text                                                                         as first_name
    , person_assistant_phone::text                                                             as person_assistant_phone
    , convert_timezone('America/Chicago' , _fivetran_synced)::timestamp_ntz                    as _fivetran_synced
    , convert_timezone('America/Chicago' , last_viewed_date)::timestamp_ntz                    as last_viewed_date
    , account_number::text                                                                     as account_number
    , name::text                                                                               as name
    , referral_source_pc::text                                                                 as referral_source_pc
    , shipping_country::text                                                                   as shipping_country
    , person_other_phone::text                                                                 as person_other_phone
    , convert_timezone('America/Chicago' , person_last_curequest_date)::timestamp_ntz          as person_last_curequest_date
    , person_other_postal_code::text                                                           as person_other_postal_code
    , convert_timezone('America/Chicago' , person_last_cuupdate_date)::timestamp_ntz           as person_last_cuupdate_date
    , person_mailing_state::text                                                               as person_mailing_state
    , last_modified_by_id::text                                                                as last_modified_by_id
    , business_address_postal_code_pc::text                                                    as business_address_postal_code_pc
    , lead_source_pc::text                                                                     as lead_source_pc
    , client_propsect_ai_summary_pc::text                                                      as client_propsect_ai_summary_pc
    , fin_serv_notes_c::text                                                                   as fin_serv_notes_c
    , client_ai_summary_c::text                                                                as client_ai_summary_c
    , dd_firm_crd_branch_id_pc::text                                                           as dd_firm_crd_branch_id_pc
    , business_email_pc::text                                                                  as business_email_pc
    , jigsaw_company_id::text                                                                  as jigsaw_company_id
    , speed_to_contact_days_pc::float                                                          as speed_to_contact_days_pc
    , business_address_state_pc::text                                                          as business_address_state_pc
    , convert_timezone('America/Chicago' , first_call_date_time_pc)::timestamp_ntz             as first_call_date_time_pc
    , dd_firm_crd_branch_id_c::text                                                            as dd_firm_crd_branch_id_c
    , person_other_city::text                                                                  as person_other_city
    , referral_employee_pc::boolean                                                            as referral_employee_pc
    , fax::text                                                                                as fax
    , shipping_state::text                                                                     as shipping_state
    , person_other_longitude::float                                                            as person_other_longitude
    , person_mobile_phone::text                                                                as person_mobile_phone
    , is_person_account::boolean                                                               as is_person_account
    , shipping_geocode_accuracy::text                                                          as shipping_geocode_accuracy
    , webinars_opt_out_pc::boolean                                                             as webinars_opt_out_pc
    , convert_timezone('America/Chicago' , person_first_call_date_time)::timestamp_ntz         as person_first_call_date_time
    , owner_id::text                                                                           as owner_id
    , middle_name::text                                                                        as middle_name
    , billing_state::text                                                                      as billing_state
    , data_migration_helper_pc::boolean                                                        as data_migration_helper_pc
    , ownership::text                                                                          as ownership
    , shipping_street::text                                                                    as shipping_street
    , description::text                                                                        as description
    , compass_contact_id_pc::text                                                              as compass_contact_id_pc
    , dd_rep_crd_pc::text                                                                      as dd_rep_crd_pc
    , shipping_longitude::float                                                                as shipping_longitude
    , newsletter_opt_out_pc::boolean                                                           as newsletter_opt_out_pc
    , suffix::text                                                                             as suffix
    , person_mailing_country::text                                                             as person_mailing_country
    , last_activity_date::date                                                                 as last_activity_date
    , marketing_cloud_undeliverable_pc::boolean                                                as marketing_cloud_undeliverable_pc
    , initial_call_pc::float                                                                   as initial_call_pc
    , person_contact_id::text                                                                  as person_contact_id
    , convert_timezone('America/Chicago' , created_date)::timestamp_ntz                        as created_date
    , rating::text                                                                             as rating
    , billing_geocode_accuracy::text                                                           as billing_geocode_accuracy
    , person_individual_id::text                                                               as person_individual_id
    , lead_source_c::text                                                                      as lead_source_c
    , speed_to_contact_hours_pc::float                                                         as speed_to_contact_hours_pc
    , activity_metric_id::text                                                                 as activity_metric_id
    , convert_timezone('America/Chicago' , last_referenced_date)::timestamp_ntz                as last_referenced_date
    , person_mailing_city::text                                                                as person_mailing_city
    , person_mailing_longitude::float                                                          as person_mailing_longitude
    , convert_timezone('America/Chicago' , person_first_email_date_time)::timestamp_ntz        as person_first_email_date_time
    , preferred_contact_method_pc::text                                                        as preferred_contact_method_pc
    , person_other_geocode_accuracy::text                                                      as person_other_geocode_accuracy
    , convert_timezone('America/Chicago' , last_modified_date)::timestamp_ntz                  as last_modified_date
    , type::text                                                                               as type
    , person_mailing_postal_code::text                                                         as person_mailing_postal_code
    , is_priority_record::boolean                                                              as is_priority_record
    , sic_desc::text                                                                           as sic_desc
    , convert_timezone('America/Chicago' , system_modstamp)::timestamp_ntz                     as system_modstamp
    , account_source::text                                                                     as account_source
    , sic::text                                                                                as sic
    , person_mailing_latitude::float                                                           as person_mailing_latitude
    , industry::text                                                                           as industry
    , potential_aum_pc::number(18 , 2)                                                         as potential_aum_pc
    , person_other_street::text                                                                as person_other_street
    , number_of_employees::number(18 , 2)                                                      as number_of_employees
    , referral_branch_pc::text                                                                 as referral_branch_pc
    , notification_id_pc::text                                                                 as notification_id_pc
    , person_other_country::text                                                               as person_other_country
    , are_you_a_pc::text                                                                       as are_you_a_pc
    , person_birthdate::date                                                                   as person_birthdate
    , billing_city::text                                                                       as billing_city
from {{ source('salesforce_og', 'account') }}
