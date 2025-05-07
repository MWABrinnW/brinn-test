{% macro select_crm_salesforce_baystate() -%}
  , 'salesforce'::text                              as crm
  , 'baystate'::text                                as crm_instance_location
  , concat(crm, '__' , crm_instance_location)::text as crm_key
  , null::text                                      as crm_custodian
  , null::text                                      as crm_account_id
  , null::text                                      as crm_account_type
  , null::text                                      as crm_account_name
  , null::text                                      as crm_registrant_name
  , null::text                                      as crm_client_id
  , null::text                                      as crm_client_name
  , null::int                                       as crm_is_active
  , null::date                                      as crm_created_date
  , null::date                                      as crm_opened_date
  , null::date                                      as crm_closed_date
  , null::number(18 , 2)                            as crm_account_value
  , sf1_bay.advisor::text                           as crm_advisor
  , sf1_bay.advisor_id::text                        as crm_advisor_id
  , crm_key::text                                   as crm_advisor_id_source
  , null::text                                      as crm_advisor_email
  , null::text                                      as crm_location_code
  , null::text                                      as crm_fee_schedule
  , null::text                                      as crm_model_investment_strategy
  , null::text                                      as crm_aum_classification
  , null::int                                       as crm_is_erisa
  , null::int                                       as crm_is_discretionary
  , null::int                                       as crm_is_voting_proxied
  , null::int                                       as crm_is_prime_broker
  , null::int                                       as crm_is_broker_dealer_account
{% endmacro -%}
