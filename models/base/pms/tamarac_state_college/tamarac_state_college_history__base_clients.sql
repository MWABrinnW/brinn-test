select
    'tamarac'                                                                   as system_name
    , 'state_college'                                                           as system_instance
    , system_name || '__' || system_instance                                    as system_key
    , 'mwa'                                                                     as firm_source
    , content:EMAIL::varchar(1024)                                              as email
    , content:ACTIVATION_EMAIL_SENT::boolean                                    as activation_email_sent
    , content:ALLOW_PORTAL_ACCESS::boolean                                      as allow_portal_access
    , content:CLIENT_STATUS::varchar(1024)                                      as client_status
    , content:CLIENT_VIEW::varchar(1024)                                        as client_view
    , content:CUSTOM_SIGNATURE::varchar(1024)                                   as custom_signature
    , content:USE_DEFAULT_CUSTOMER_SIGNATURE::boolean                           as use_default_customer_signature
    , content:DATE_OF_BIRTH::date                                               as date_of_birth
    , content:DEFAULT_ACCOUNT::varchar(1024)                                    as default_account
    , content:DEFAULT_ACCOUNT_NAME::varchar(1024)                               as default_account_name
    , content:DEFAULT_ACCOUNT_NUMBER::varchar(1024)                             as default_account_number
    , content:DEFAULT_UPLOAD_ACCOUNT_ID::varchar(1024)                          as default_upload_account_id
    , content:FIRST_NAME::varchar(1024)                                         as first_name
    , content:HOUSEHOLD_NAME::varchar(1024)                                     as household_name
    , content:LAST_LOGIN_DATE::date                                             as last_login_date
    , content:LAST_NAME::varchar(1024)                                          as last_name
    , content:MIDDLE_NAME_INITIAL::varchar(1024)                                as middle_name_initial
    , content:PREFERRED_DELIVERY_METHOD::varchar(1024)                          as preferred_delivery_method
    , content:SERVICE_TEAM_NAME::varchar(1024)                                  as service_team_name
    , content:SERVICE_TEAM_COMPLIANCE::varchar(1024)                            as service_team_compliance
    , content:SERVICE_TEAM_CSA::varchar(1024)                                   as service_team_csa
    , content:SERVICE_TEAM_OPERATIONS::varchar(1024)                            as service_team_operations
    , content:SERVICE_TEAM_PRIMARY_ADVISOR::varchar(1024)                       as service_team_primary_advisor
    , content:SERVICE_TEAM_SECONDARY_ADVISOR::varchar(1024)                     as service_team_secondary_advisor
    , content:SERVICE_TEAM_SOLICITOR::varchar(1024)                             as service_team_solicitor
    , content:SERVICE_TEAM_TRADE_APPROVER::varchar(1024)                        as service_team_trade_approver
    , content:SERVICE_TEAM_TRADER::varchar(1024)                                as service_team_trader
    , content:UPLOAD_HOUSEHOLD_ID::varchar(1024)                                as upload_household_id
    , content:PREV_EOD_DATE::date                                               as prev_eod_date
    , effective_date                                                            as effective_date
    , row_number() over (partition by effective_date order by _created_at desc) as rn
    , {{ col_is_head(
        reference=source('tamarac_state_college', 'clients')
        ) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _created_at                                                               as _created_at
    , _source_file                                                              as _source_file
from {{ source('tamarac_state_college', 'clients') }}
