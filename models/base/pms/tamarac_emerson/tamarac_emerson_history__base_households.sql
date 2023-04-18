select
    'tamarac' as pms
    , 'emerson' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , prev_eod_date
    , household_name
    , upload_household_id
    , "Field1" as field1
    , household_address1
    , household_address2
    , household_address3
    , household_address4
    , household_city
    , household_state
    , household_state_of_primary_residence
    , household_zip
    , household_country
    , is_primary_residence
    , primary_email_address
    , managed_value
    , total_value
    , net_worth
    , service_team
    , client_type
    , associated_clients
    , associated_custodians
    , associated_models
    , associated_target_allocations
    , enabled_for_client_portal
    , household_address5
    , household_address6
    , logo
    , override_addresses_of_direct_member_accounts
    , primary_client
    , service_team_compliance
    , service_team_csa
    , service_team_operations
    , service_team_primary_advisor
    , service_team_secondary_advisor
    , service_team_trade_approver
    , service_team_trader
    , total_billed_amount
    , total_value_excluded_from_billing
    , total_value_included_in_billing
    , unmanaged_value
    , domestic
    , relationship_end_date
    , relationship_start_date
    , {{ col_is_head(reference=source('tamarac_emerson', 'households')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('tamarac_emerson', 'households') }}