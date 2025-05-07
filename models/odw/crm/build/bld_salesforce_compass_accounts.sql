{{config(
    materialized='incremental',
    unique_key='effective_at::date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    tags=["financials"]
)}}

select
    ei.effective_at                                           as effective_at
  , ei.system_name                                            as system_name
  , ei.system_instance                                        as system_instance
  , ei.system_key                                             as system_key
  , ei.firm_source                                            as firm_source
  , ei.id                                                     as id
  , ei.estate_item_id_18_c                                    as estate_item_id
  , ei.owner_id                                               as owner_id
  , ei.is_deleted::int                                        as is_deleted
  , ei.as_of_date_c::date                                     as as_of_date
  , ei.name::text(500)                                        as account_name
  , null::text(200)                                           as registrant_name
  , ei.account_idorion_c                                      as orion_account_id
  , regexp_replace(
    ltrim(upper(
      replace(
        ei.identifier_c, '-', ''
      )
    ), '0')::text(200)
    , '\\s{2,}', ' '
  )                                                           as account_number
  , ei.identifier_c                                           as account_number_formatted
  , ei.account_type_c                                         as account_type
  , ei.registration_type_c                                    as registration_type_id
  , regtype.name                                              as registration_type
  , try_to_boolean(regtype.is_qualified_c)::int               as is_qualified
  , cust.name                                                 as custodian
  , case
    when cust.name ilike '%schwab%'
      then 'schwab'
    when cust.name ilike '%fidel%'
      then 'fidelity'
    when cust.name ilike '%lpl%'
      then 'lpl'
    when cust.name ilike '%pershing%'
      then 'pershing'
    when cust.name ilike '%tda%'
      or cust.name ilike '%ameritrade%'
      then 'tda'
    else cust.name
  end::text(100)                                              as custodian_key
  , case
    when ei.closing_date_c is not null
      then 0
    when ei.status_c in ('Open', 'Converted')
      then 1
    when ei.status_c in ('Closed', 'Dormant')
      then 0
    else 0
  end::int                                                    as is_active
  , ei.current_value_c::decimal(16, 2)                        as account_value
  , ei.opening_date_c                                         as opened_date
  , ei.closing_date_c                                         as closed_date
  , ei.location_c                                             as location_name
  , ei.record_type_id                                         as record_type_id
  , ei.created_date::timestamp_tz                             as created_at
  , ei.created_by_id                                          as created_by_id
  , ei.last_modified_date::timestamp_tz                       as last_modified_at
  , ei.last_modified_by_id                                    as last_modified_by_id
  , ei.system_modstamp::timestamp_tz                          as system_modstamp_at
  , ei.aum_classification_c                                   as aum_classification
  , ei.aum_classification_notes_c                             as aum_classification_notes
  , case
    when lower(ei.erisa_c) = 'confirmed erisa'
      then 1
    else 0
  end::int                                                    as is_erisa
  , try_to_boolean(ei.prime_broker_enabled_c)::int            as is_prime_broker
  , (not try_to_boolean(ei.non_discretionary_account_c))::int as is_discretionary
  , try_to_boolean(ei.broker_dealer_account_c)::int           as is_broker_dealer_account
  , null::int                                                 as is_voting_proxied
  , fs.id                                                     as fee_schedule_id
  , fs.name                                                   as fee_schedule
  , ei.household_c                                            as household_id
  , c.id                                                      as client_id
  , c.unique_identifier_c                                     as unique_identifier
  , c.name                                                    as household_name
  , c.orion_house_id_c                                        as orion_client_id
  , c.type                                                    as household_type
  , c.account_opened_c::date                                  as household_opened_date
  , c.mariner_location_c                                      as household_location_id
  , loc.finance_code_c                                        as household_location_code
  , loc.accounting_id_c                                       as household_accounting_id
  , c.lead_source_c                                           as household_lead_source
  , c.account_source                                          as household_account_source
  , c.legal_firm_c                                            as household_legal_firm
  , c.billing_street::text(200)                               as billing_street
  , c.billing_city::text(200)                                 as billing_city
  , c.billing_state::text(200)                                as billing_state
  , c.billing_postal_code::text(200)                          as billing_postal_code
  , c.billing_country::text(200)                              as billing_country
  , c.legal_street_address_c::text(200)                       as legal_street_address
  , c.legal_address_city_c::text(200)                         as legal_address_city
  , c.legal_address_state_c::text(200)                        as legal_address_state
  , c.legal_address_postal_code_c::text(200)                  as legal_address_postal_code
  , c.mailing_street_address_c::text(200)                     as mailing_street_address
  , c.mailing_street_address_2_c::text(200)                   as mailing_street_address_2
  , c.mailing_street_address_3_c::text(200)                   as mailing_street_address_3
  , c.mailing_city_c::text(200)                               as mailing_city
  , c.mailing_state_c::text(200)                              as mailing_state
  , c.mailing_postal_code_c::text(200)                        as mailing_postal_code
  , c.shipping_street::text(200)                              as shipping_street
  , c.shipping_city::text(200)                                as shipping_city
  , c.shipping_state::text(200)                               as shipping_state
  , c.shipping_postal_code::text(200)                         as shipping_postal_code
  , c.shipping_country::text(200)                             as shipping_country
  , c.other_street_address_c::text(200)                       as other_street_address
  , c.other_street_address_2_c::text(200)                     as other_street_address_2
  , c.other_city_c::text(200)                                 as other_city
  , c.other_state_c::text(200)                                as other_state
  , c.other_postal_code_c::text(200)                          as other_postal_code
  , c.key_tags_c::text(5000)                                  as key_tags
  , contact.name                                              as owner_name
  , ownr.name::text                                           as client_manager
  , ownr.email::text                                          as client_manager_email
  , ownr.employee_number::text                                as employee_number
  , case 
      when (left(ownr.employee_number, 1) = '1'
       and len(ownr.employee_number) = 6) 
        then 'oracle__hcm' 
    else null end::text                                       as employee_number_source
  , mdl.name                                                  as investment_strategy
  , ei.partner_firm_c                                         as partner_firm
  , ei.trading_system_c                                       as trading_system
  , row_number() over (
    partition by
        ei.effective_at::date
        , regexp_replace(
    ltrim(upper(
      replace(
        ei.identifier_c, '-', ''
      )
    ), '0')::text(200)
    , '\\s{2,}', ' '
  )
    order by
        date_trunc('second' , ei.effective_at)::datetime desc
        , (case
    when ei.closing_date_c is not null
      then 0
    when ei.status_c in ('Open', 'Converted')
      then 1
    when ei.status_c in ('Closed', 'Dormant')
      then 0
    else 0
  end::int) desc
        , ei.current_value_c desc nulls last)                 as rn_acct_num
  , ei._fivetran_synced                                       as _fivetran_synced
  , current_timestamp::timestamp_ntz                          as _created_at
    , ei._created_at                                          as _source_loaded_at
    , ei.effective_at::date                                   as effective_date
from {{ ref('salesforce_compass__base_estate_item_c') }} as ei
left join {{ ref('salesforce_compass__base_account') }} as c
    on ei.household_c = c.id
    and ei.effective_at::date = c.effective_at::date
    and c.is_latest = 1
  and coalesce(c.is_deleted, 0) = 0
  and coalesce(c._fivetran_deleted, 0) = 0
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on fs.id = ei.fee_schedule_c
    and fs.effective_at::date = ei.effective_at::date
    and fs.is_latest = 1
left join {{ ref('salesforce_compass__base_contact') }} as contact
    on c.client_manager_c = contact.id
    and c.effective_at::date = contact.effective_at::date
    and contact.is_latest = 1
left join {{ ref('salesforce_compass__base_mh_dynamic_list_c') }} as regtype
    on ei.registration_type_c = regtype.id
    and regtype.is_head = 1
left join {{ ref('salesforce_compass__base_model_c') }} as mdl
    on ei.model_on_account_c = mdl.id
left join {{ ref('salesforce_compass__base_user') }} as ownr
    on c.owner_id = ownr.id
    and ownr.is_head = 1
left join {{ ref('salesforce_compass__base_mh_location_c') }} as loc
    on c.mariner_location_c = loc.id
    and ei.effective_at::date = loc.effective_at::date
    and loc.is_latest = 1
left join {{ ref('salesforce_compass__base_custodian_c') }} as cust
    on ei.custodian_c = cust.id
    and ei.effective_at::date = cust.effective_at::date
    and cust.is_latest = 1
    and cust.is_deleted = false
where true
  {{ incremental_date_filter(
          source_col_name = 'ei.effective_at',
          target_col_name = 'effective_at',
          do_lookback = false,
          do_new = true,
          custom_condition_only = false,
          custom_condition = none
    ) }}
    and coalesce(ei.is_deleted, 0) = 0
    and coalesce(ei._fivetran_deleted, 0) = 0
    and ei.is_latest = 1
order by ei.effective_at, account_number
