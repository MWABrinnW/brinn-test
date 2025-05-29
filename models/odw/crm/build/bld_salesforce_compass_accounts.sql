{{ config(
    materialized='incremental',
    unique_key='effective_at::date',
    incremental_strategy='delete+insert',
    on_schema_change='sync_all_columns',
    tags=["financials"],
    cluster_by=['effective_at::date']
) }}

{%- set start_date = '2021-12-31' -%}
{%- set lookback = cvar('lookback') -%}


with source_summary as (
  select
    effective_at, max(_created_at) as _created_at
  from {{ ref('salesforce_compass__base_estate_item_c') }}
  where 1 = 1
    -- Model start date. This applies for full-refresh.
    and effective_at::date >= '{{ start_date }}'
    -- Restrict lookback window if incremental or not prod.
    and effective_at::date >= current_date() - {{ lookback }}
  group by all
  order by 1
)

, destination_summary as (
  select
    effective_at, max(_created_at) as _created_at
  from {{ this }}
  where 1 = 1
    -- Model start date. This applies for full-refresh.
    and effective_at::date >= '{{ start_date }}'
    -- Restrict lookback window if incremental or not prod.
    and effective_at::date >= current_date() - {{ lookback }}
  group by all
  order by 1
)

, summary_spine as (
  select effective_at::date as effective_date from source_summary
  union
  select effective_at::date as effective_date from destination_summary
)

, dates_to_refresh as (
  select
    a.effective_date
  from summary_spine a
  left join source_summary s
    on a.effective_date = s.effective_at::date
  left join destination_summary d
    on a.effective_date = d.effective_at::date
  where 1 = 1
    and (
      s._created_at > coalesce(d._created_at, s._created_at - interval '1 day')
    )
  order by 1
)

--------------------------------------------------

, estate_item as (
  select
    effective_at
    , system_name
    , system_instance
    , system_key
    , firm_source
    , id
    , estate_item_id_18_c
    , owner_id
    , is_deleted
    , as_of_date_c
    , name
    , account_idorion_c
    , identifier_c
    , account_type_c
    , registration_type_c
    , closing_date_c
    , status_c
    , current_value_c
    , opening_date_c
    , location_c
    , record_type_id
    , created_date
    , created_by_id
    , last_modified_date
    , last_modified_by_id
    , system_modstamp
    , aum_classification_c
    , aum_classification_notes_c
    , erisa_c
    , prime_broker_enabled_c
    , non_discretionary_account_c
    , broker_dealer_account_c
    , partner_firm_c
    , trading_system_c
    , _fivetran_synced
    , _created_at
    , is_latest
    , model_on_account_c
    , fee_schedule_c
    , custodian_c
    , household_c
  from {{ ref('salesforce_compass__base_estate_item_c') }}
  where 1 = 1
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
    and effective_at::date in (select distinct effective_date from dates_to_refresh)
    and coalesce(is_deleted, 0) = 0
    and coalesce(_fivetran_deleted, 0) = 0
    -- Use qualify instead, otherwise a full table scan is occuring.
    --and is_head_for_day = 1
  qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, account as (
  select
    effective_at
    , id
    , unique_identifier_c
    , name
    , orion_house_id_c
    , type
    , account_opened_c
    , mariner_location_c
    , lead_source_c
    , account_source
    , legal_firm_c
    , billing_street
    , billing_city
    , billing_state
    , billing_postal_code
    , billing_country
    , legal_street_address_c
    , legal_address_city_c
    , legal_address_state_c
    , legal_address_postal_code_c
    , mailing_street_address_c
    , mailing_street_address_2_c
    , mailing_street_address_3_c
    , mailing_city_c
    , mailing_state_c
    , mailing_postal_code_c
    , shipping_street
    , shipping_city
    , shipping_state
    , shipping_postal_code
    , shipping_country
    , other_street_address_c
    , other_street_address_2_c
    , other_city_c
    , other_state_c
    , other_postal_code_c
    , key_tags_c
    , owner_id
    , client_manager_c
  from {{ ref('salesforce_compass__base_account') }}
  where 1 = 1
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
    and effective_at::date in (select distinct effective_date from dates_to_refresh)
    -- Use qualify instead, otherwise a full table scan is occuring.
    --and is_head_for_day = 1
    and coalesce(is_deleted, 0) = 0
    and coalesce(_fivetran_deleted, 0) = 0
  qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

, contact as (
  select
    effective_at, id, name
  from {{ ref('salesforce_compass__base_contact') }}
  where 1 = 1
    -- Offer the snowflake query optimizer a chance to prune the query early
    -- if there are no dates to refresh.
    and exists (select 1 from dates_to_refresh)
    and effective_at::date in (select distinct effective_date from dates_to_refresh)
    -- Use qualify instead, otherwise a full table scan is occuring.
    and is_head_for_day = 1
  qualify _created_at = max(_created_at) over(partition by effective_at::date)
)

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
  , null::text(500)                                           as registrant_name
  , ei.account_idorion_c                                      as orion_account_id
  , regexp_replace(
    ltrim(upper(
      replace(
        ei.identifier_c, '-', ''
      )
    ), '0')::text(500)
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
  , c.billing_street::text(500)                               as billing_street
  , c.billing_city::text(500)                                 as billing_city
  , c.billing_state::text(500)                                as billing_state
  , c.billing_postal_code::text(500)                          as billing_postal_code
  , c.billing_country::text(500)                              as billing_country
  , c.legal_street_address_c::text(500)                       as legal_street_address
  , c.legal_address_city_c::text(500)                         as legal_address_city
  , c.legal_address_state_c::text(500)                        as legal_address_state
  , c.legal_address_postal_code_c::text(500)                  as legal_address_postal_code
  , c.mailing_street_address_c::text(500)                     as mailing_street_address
  , c.mailing_street_address_2_c::text(500)                   as mailing_street_address_2
  , c.mailing_street_address_3_c::text(500)                   as mailing_street_address_3
  , c.mailing_city_c::text(500)                               as mailing_city
  , c.mailing_state_c::text(500)                              as mailing_state
  , c.mailing_postal_code_c::text(500)                        as mailing_postal_code
  , c.shipping_street::text(500)                              as shipping_street
  , c.shipping_city::text(500)                                as shipping_city
  , c.shipping_state::text(500)                               as shipping_state
  , c.shipping_postal_code::text(500)                         as shipping_postal_code
  , c.shipping_country::text(500)                             as shipping_country
  , c.other_street_address_c::text(500)                       as other_street_address
  , c.other_street_address_2_c::text(500)                     as other_street_address_2
  , c.other_city_c::text(500)                                 as other_city
  , c.other_state_c::text(500)                                as other_state
  , c.other_postal_code_c::text(500)                          as other_postal_code
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
    ), '0')::text(500)
    , '\\s{2,}', ' '
  )
    order by
        ei.effective_at desc
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
  , ei._created_at                                            as _source_loaded_at
from estate_item as ei
left join account as c
    on ei.effective_at::date = c.effective_at::date
    and ei.household_c = c.id
left join {{ ref('salesforce_compass__base_fee_schedule_c') }} as fs
    on fs.effective_at::date = ei.effective_at::date
    and fs.id = ei.fee_schedule_c
    and fs.is_head_for_day = 1
    and exists (select 1 from dates_to_refresh)
    and fs.effective_at::date in (select distinct effective_date from dates_to_refresh)
left join contact as contact
    on c.effective_at::date = contact.effective_at::date
    and c.client_manager_c = contact.id
left join {{ ref('salesforce_compass__base_mh_dynamic_list_c') }} as regtype
    on ei.registration_type_c = regtype.id
    and regtype.is_head = 1
left join {{ ref('salesforce_compass__base_model_c') }} as mdl
    on ei.model_on_account_c = mdl.id
left join {{ ref('salesforce_compass__base_user') }} as ownr
    on c.owner_id = ownr.id
    and ownr.is_head = 1
left join {{ ref('salesforce_compass__base_mh_location_c') }} as loc
    on ei.effective_at::date = loc.effective_at::date
    and c.mariner_location_c = loc.id
    and loc.is_head_for_day = 1
    and exists (select 1 from dates_to_refresh)
    and loc.effective_at::date in (select distinct effective_date from dates_to_refresh)
left join {{ ref('salesforce_compass__base_custodian_c') }} as cust
    on ei.effective_at::date = cust.effective_at::date
    and ei.custodian_c = cust.id
    and cust.is_head_for_day = 1
    and cust.is_deleted = false
    and exists (select 1 from dates_to_refresh)
    and cust.effective_at::date in (select distinct effective_date from dates_to_refresh)
where 1 = 1
order by ei.effective_at, account_number
