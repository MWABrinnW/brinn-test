{% macro select_crm_null() -%}
  , null::varchar(200)                                               as crm
  , null::varchar(200)                                               as crm_instance_location
  , concat(crm, '__', crm_instance_location)                         as crm_key
  , null::varchar(200)                                               as crm_custodian
  , null::varchar(200)                                               as crm_account_id
  , null::varchar(200)                                               as crm_account_type
  , null::varchar(200)                                               as crm_account_name
  , null::varchar(200)                                               as crm_registrant_name
  , null::varchar(200)                                               as crm_household_id
  , null::varchar(200)                                               as crm_household_name
  , null::int                                                        as crm_is_active
  , null::date                                                       as crm_created_date
  , null::date                                                       as crm_opened_date
  , null::date                                                       as crm_closed_date
  , null::decimal(16, 2)                                             as crm_account_value
  , null::varchar(200)                                               as crm_advisor
  , null::varchar(200)                                               as crm_advisor_email
  , null::varchar(200)                                               as crm_location_code
  , null::varchar(200)                                               as crm_fee_schedule
  , null::varchar(200)                                               as crm_investment_strategy
  , null::varchar(200)                                               as crm_aum_classification
  , null::int                                                        as crm_is_erisa
  , null::int                                                        as crm_is_discretionary
  , null::int                                                        as crm_is_voting_proxied
  , null::int                                                        as crm_is_prime_broker
  , null::int                                                        as crm_is_broker_dealer_account
{% endmacro -%}
