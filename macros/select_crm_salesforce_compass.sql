{% macro select_crm_salesforce_compass() -%}
  , coalesce(sf1.system_name , sf2.system_name)                                as crm
  , coalesce(sf1.system_instance , sf2.system_instance)                        as crm_instance_location
  , coalesce(sf1.system_key , sf2.system_key)                                  as crm_key
  , sf1.custodian                                                              as crm_custodian
  , coalesce(sf1.estate_item_id , sf2.estate_item_id)                          as crm_account_id
  , coalesce(sf1.account_type , sf2.account_type , 
      sf1.registration_type , sf1.registration_type)                           as crm_account_type
  , coalesce(sf1.account_name , sf2.account_name)                              as crm_account_name
  , coalesce(sf1.registrant_name , sf2.registrant_name)                        as crm_registrant_name
  , coalesce(sf1.household_id , sf2.household_id)                              as crm_client_id
  , coalesce(sf1.household_name , sf2.household_name)                          as crm_client_name
  , coalesce(sf1.is_active , sf2.is_active)                                    as crm_is_active
  , coalesce(sf1.created_at , sf2.created_at)::date                            as crm_created_date
  , coalesce(sf1.opened_date , sf2.opened_date)                                as crm_opened_date
  , coalesce(sf1.closed_date , sf2.closed_date)                                as crm_closed_date
  , coalesce(sf1.account_value , sf2.account_value)                            as crm_account_value
  , coalesce(sf1.client_manager , sf2.client_manager)                          as crm_advisor
  , coalesce(sf1.client_manager_email , sf2.client_manager_email)              as crm_advisor_email
  , coalesce(sf1.household_location_code , sf2.household_location_code)        as crm_location_code
  , coalesce(sf1.fee_schedule , sf2.fee_schedule)                              as crm_fee_schedule
  , coalesce(sf1.investment_strategy , sf2.investment_strategy)                as crm_model_investment_strategy
  , coalesce(sf1.aum_classification , sf2.aum_classification)                  as crm_aum_classification
  , coalesce(sf1.is_erisa , sf2.is_erisa)                                      as crm_is_erisa
  , coalesce(sf1.is_discretionary , sf2.is_discretionary)                      as crm_is_discretionary
  , coalesce(sf1.is_voting_proxied , sf2.is_voting_proxied)                    as crm_is_voting_proxied
  , coalesce(sf1.is_prime_broker , sf2.is_prime_broker)                        as crm_is_prime_broker
  , coalesce(sf1.is_broker_dealer_account , sf2.is_broker_dealer_account)      as crm_is_broker_dealer_account
{% endmacro -%}
