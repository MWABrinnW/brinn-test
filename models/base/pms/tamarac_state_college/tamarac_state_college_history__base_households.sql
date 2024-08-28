select
    'tamarac'                                                                   as system_name
    , 'state_college'                                                           as system_instance
    , system_name || '__' || system_instance                                    as system_key
    , 'mwa'                                                                     as firm_source
    , content:SERVICE_TEAM_COMPLIANCE::varchar(254)                             as service_team_compliance
    , content:SERVICE_TEAM_OPERATIONS::varchar(254)                             as service_team_operations
    , content:SERVICE_TEAM_PRIMARY_ADVISOR::varchar(254)                        as service_team_primary_advisor
    , content:SERVICE_TEAM_SECONDARY_ADVISOR::varchar(254)                      as service_team_secondary_advisor
    , content:SERVICE_TEAM_CSA::varchar(254)                                    as service_team_csa
    , content:SERVICE_TEAM_TRADE_APPROVER::varchar(254)                         as service_team_trade_approver
    , content:SERVICE_TEAM_TRADER::varchar(254)                                 as service_team_trader
    , content:HOUSEHOLD_NAME::varchar(254)                                      as household_name
    , content:ASSOCIATED_CLIENTS::varchar(254)                                  as associated_clients
    , content:ASSOCIATED_CUSTODIANS::varchar(254)                               as associated_custodians
    , content:ASSOCIATED_MODELS::varchar(254)                                   as associated_models
    , content:ASSOCIATED_TARGET_ALLOCATIONS::varchar(254)                       as associated_target_allocations
    , content:ENABLED_FOR_CLIENT_PORTAL::varchar(254)                           as enabled_for_client_portal
    , content:HOUSEHOLD_ADDRESS1::varchar(254)                                  as household_address1
    , content:HOUSEHOLD_ADDRESS2::varchar(254)                                  as household_address2
    , content:HOUSEHOLD_ADDRESS3::varchar(254)                                  as household_address3
    , content:HOUSEHOLD_ADDRESS4::varchar(254)                                  as household_address4
    , content:HOUSEHOLD_ADDRESS5::varchar(254)                                  as household_address5
    , content:HOUSEHOLD_ADDRESS6::varchar(254)                                  as household_address6
    , content:HOUSEHOLD_CITY::varchar(254)                                      as household_city
    , content:HOUSEHOLD_COUNTRY::varchar(254)                                   as household_country
    , content:HOUSEHOLD_STATE::varchar(254)                                     as household_state
    , content:HOUSEHOLD_STATE_OF_PRIMARY_RESIDENCE::varchar(254)                as household_state_of_primary_residence
    , content:HOUSEHOLD_ZIP::varchar(254)                                       as household_zip
    , content:IS_PRIMARY_RESIDENCE::varchar(254)                                as is_primary_residence
    , content:LOGO::varchar(254)                                                as logo
    , content:MANAGED_VALUE::varchar(254)                                       as managed_value
    , content:NET_WORTH::varchar(254)                                           as net_worth
    , content:OVERRIDE_ADDRESSES_OF_DIRECT_MEMBER_ACCOUNTS::varchar(254)        as override_addresses_of_direct_member_accounts
    , content:PRIMARY_CLIENT::varchar(254)                                      as primary_client
    , content:PRIMARY_EMAIL_ADDRESS::varchar(254)                               as primary_email_address
    , content:SERVICE_TEAM::varchar(254)                                        as service_team
    , content:SERVICE_TEAM_SOLICITER::varchar(254)                              as service_team_soliciter
    , content:TOTAL_BILLED_AMOUNT::varchar(254)                                 as total_billed_amount
    , content:TOTAL_VALUE::varchar(254)                                         as total_value
    , content:TOTAL_VALUE_EXCLUDED_FROM_BILLING::varchar(254)                   as total_value_excluded_from_billing
    , content:TOTAL_VALUE_INCLUDED_IN_BILLING::varchar(254)                     as total_value_included_in_billing
    , content:UNMANAGED_VALUE::varchar(254)                                     as unmanaged_value
    , content:UPLOAD_HOUSEHOLD_ID::varchar(254)                                 as upload_household_id
    , content:CLIENT_TYPE::varchar(254)                                         as client_type
    , content:DOMESTIC::varchar(254)                                            as domestic
    , content:RELATIONSHIP_END_DATE::date                                       as relationship_end_date
    , content:RELATIONSHIP_START_DATE::date                                     as relationship_start_date
    , content:BOARD_MEMBER_OFFICIAL_SR_MANAGEMENT_OF_PTC::varchar(254)          as board_member_official_sr_management_of_ptc
    , content:SOLICITOR_RELATED_HOUSEHOLD::varchar(254)                         as solicitor_related_household
    , effective_date                                                            as effective_date
    , dense_rank() over (partition by effective_date order by _created_at desc) as rn
    , {{ col_is_head(
        reference=source('tamarac_state_college', 'accounts')
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                               as _created_at
    , _id                                                                       as _id
from {{ source('tamarac_state_college', 'households') }}
