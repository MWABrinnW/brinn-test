select
      ei.effective_at                                     as effective_at
    , ei.id                                               as id
    , ei.estate_item_id_18_c                              as estate_item_id
    , ei.owner_id                                         as owner_id
    , ei.is_deleted::int                                  as is_deleted
    , ei.name                                             as account_name
    , ei.account_idorion_c                                as orion_account_id
    , ei.identifier_c                                     as account_number
    , ei.account_type_c                                   as account_type
    , ei.registration_type_c                              as registration_type_id
    , regtype.name                                        as registration_type
    , try_to_boolean(regtype.is_qualified_c)::int         as is_qualified
    , ei.custodian_c                                      as custodian
    , case
        when ei.closing_date_c is not null
            then 0
        when ei.status_c in ('Open', 'Converted')
            then 1
        when ei.status_c in ('Closed', 'Dormant')
            then 0
        else 0
        end::int                                          as is_active
    , ei.opening_date_c                                   as opened_date
    , ei.closing_date_c                                   as closed_date
    , ei.location_c                                       as location
    , ei.record_type_id                                   as record_type_id
    , ei.created_date::timestamp_tz                       as created_at
    , ei.created_by_id                                    as created_by_id
    , ei.last_modified_date::timestamp_tz                 as last_modified_at
    , ei.last_modified_by_id                              as last_modified_by_id
    , ei.system_modstamp::timestamp_tz                    as system_modstamp_at
    , ei.aum_classification_c                             as aum_classification
    , ei.aum_classification_notes_c                       as aum_classification_notes
    , case
        when lower(ei.erisa_c) = 'confirmed erisa'
            then 1
        else 0
        end::int                                          as is_erisa
    , try_to_boolean(ei.prime_broker_enabled_c)::int      as is_prime_broker
    , (not try_to_boolean(ei.non_discretionary_account_c))::int as is_discretionary
    , try_to_boolean(ei.broker_dealer_account_c)::int     as is_broker_dealer_account
    , ei.fee_schedule_c                                   as fee_schedule
    , ei.household_c                                      as household_id
    , c.name                                              as household_name
    , c.orion_house_id_c                                  as orion_client_id
    , c.type                                              as household_type
    , c.mariner_location_c                                as household_location_id
    , loc.accounting_id_c                                 as household_location_code
    , contact.name                                        as owner
    , ownr.name                                           as client_manager
    , model.name                                          as investment_strategy
    , ei.partner_firm_c                                   as partner_firm
    , ei.trading_system_c                                 as trading_system
    , ei._fivetran_synced                                 as _fivetran_synced
    , ei._created_at                                      as _created_at
    , ei.is_head                                          as is_head
    , ei.is_latest                                        as is_latest
from {{ ref('salesforce_compass__base_estate_item_c') }} as ei
left join {{ ref('salesforce_compass__base_account') }} as c
    on ei.household_c = c.id
    and ei.effective_at::date = c.effective_at::date
    and c.is_latest = 1
left join {{ ref('salesforce_compass__base_contact') }} as contact
    on c.client_manager_c = contact.id
    and c.effective_at::date = contact.effective_at::date
    and contact.is_latest = 1
left join {{ ref('salesforce_compass__base_mh_dynamic_list_c') }} as regtype
    on ei.registration_type_c = regtype.id
    and regtype.is_head = 1
left join {{ ref('salesforce_compass__base_model_c') }} as model
    on ei.model_on_account_c = model.id
left join {{ ref('salesforce_compass__base_user') }} as ownr
    on c.owner_id = ownr.id
    and ownr.is_head = 1
left join {{ ref('salesforce_compass__base_mh_location_c') }} as loc
    on ei.household_c = loc.id
    and ei.effective_at::date = loc.effective_at::date
    and loc.is_latest = 1
where true
    and ei.is_latest = 1
    