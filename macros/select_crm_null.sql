{% macro select_crm_null(system_key) -%}
  , null::varchar(200)                                               as crm
  , null::varchar(200)                                               as crm_instance_location
  , concat(crm, '__', crm_instance_location)                         as crm_key
  , null::varchar(200)                                               as crm_custodian
  {% if system_key | lower in ['salesforce__compass_mic' , 'salesforce__compass_rps'] -%} 
  , pms_account_id::varchar(200)                                     as crm_account_id
  {% else %}
  , null::varchar(200)                                               as crm_account_id
  {% endif %}
  , null::varchar(200)                                               as crm_account_type
  , null::varchar(200)                                               as crm_account_name
  , null::varchar(200)                                               as crm_registrant_name
  {% if system_key | lower in ['salesforce__compass_mic' , 'salesforce__compass_rps'] -%} 
  , pms_client_id::varchar(200)                                     as crm_client_id
  {% else %}
  , null::varchar(200)                                               as crm_client_id
  {% endif %}
  , null::varchar(200)                                               as crm_client_name
  , null::int                                                        as crm_is_active
  , null::date                                                       as crm_created_date
  , null::date                                                       as crm_opened_date
  , null::date                                                       as crm_closed_date
  , null::decimal(16, 2)                                             as crm_account_value
  , null::varchar(200)                                               as crm_advisor
  , null::varchar(200)                                               as crm_advisor_email
  , null::varchar(200)                                               as crm_location_code
  , null::varchar(200)                                               as crm_fee_schedule
  , null::varchar(200)                                               as crm_model_investment_strategy
  , null::varchar(200)                                               as crm_aum_classification
  , null::int                                                        as crm_is_erisa
  , null::int                                                        as crm_is_discretionary
  , null::int                                                        as crm_is_voting_proxied
  , null::int                                                        as crm_is_prime_broker
  , null::int                                                        as crm_is_broker_dealer_account
{% endmacro -%}
