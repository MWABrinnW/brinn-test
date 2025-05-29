select
    'salesforce'::text(200)                                   as system_name
    , 'compass'::text(200)                                    as system_instance
    , concat(system_name , '__' , system_instance)::text(200) as system_key
    , 'mwa'::text(200)                                        as firm_source
    , a.json:ID::varchar(18)                                  as id
    , a.json:OWNER_ID::varchar(18)                            as owner_id
    , a.json:IS_DELETED::boolean                              as is_deleted
    , a.json:NAME::varchar(240)                               as name
    , a.json:CREATED_DATE::timestamptz                        as created_date
    , a.json:CREATED_BY_ID::varchar(18)                       as created_by_id
    , a.json:LAST_MODIFIED_DATE::timestamptz                  as last_modified_date
    , a.json:LAST_MODIFIED_BY_ID::varchar(18)                 as last_modified_by_id
    , a.json:SYSTEM_MODSTAMP::timestamptz                     as system_modstamp
    , a.json:LAST_ACTIVITY_DATE::date                         as last_activity_date
    , a.json:LAST_VIEWED_DATE::timestamptz                    as last_viewed_date
    , a.json:LAST_REFERENCED_DATE::timestamptz                as last_referenced_date
    , a.json:CONTACT_NAME_C::varchar(240)                     as contact_name_c
    , a.json:EMAIL_ADDRESS_C::varchar(450)                    as email_address_c
    , a.json:MAILING_ADDRESS_C::varchar(450)                  as mailing_address_c
    , a.json:PHONE_C::varchar(120)                            as phone_c
    , a.json:STATEMENT_DELIVERY_C::varchar(765)               as statement_delivery_c
    , a.json:STATEMENT_DELIVERY_NOTIFICATION_C::varchar(765)  as statement_delivery_notification_c
    , a.json:AVERAGE_DATE_DATA_AVAILABLE_C::varchar(765)      as average_date_data_available_c
    , a.json:DATA_SOURCE_C::varchar(765)                      as data_source_c
    , a.json:BO_RECONCILIATION_FREQUENCY_C::varchar(765)      as bo_reconciliation_frequency_c
    , a.json:LEGAL_NAME_C::varchar(300)                       as legal_name_c
    , a.json:LEGAL_ADDRESS_C::varchar(300)                    as legal_address_c
    , a.json:LEGAL_CITY_C::varchar(150)                       as legal_city_c
    , a.json:LEGAL_STATE_C::varchar(765)                      as legal_state_c
    , a.json:LEGAL_ZIP_CODE_C::varchar(45)                    as legal_zip_code_c
    , a.json:QUALIFIED_CUSTODIAN_C::varchar(765)              as qualified_custodian_c
    , a.json:QUALIFIED_LEGAL_NAME_C::varchar(300)             as qualified_legal_name_c
    , a.json:_FIVETRAN_SYNCED::timestamptz                    as _fivetran_synced
    , a.json:CURRENT_RECON_DATE_C::date                       as current_recon_date_c
    , a.json:NOTES_C::varchar(765)                            as notes_c
    , a.json:DEFAULT_CASH_SYMBOL_C::varchar(225)              as default_cash_symbol_c
    , a.json:RECON_ASSIGNMENT_C::varchar(18)                  as recon_assignment_c
    , a.json:FUND_FAMILY_C::varchar(765)                      as fund_family_c
    , a.json:_FIVETRAN_DELETED::boolean                       as _fivetran_deleted

    , a.effective_at::timestamp                               as effective_at
    , a._created_at::timestamp                                as _created_at
    , {{ col_is_head(
        reference=source('salesforce_compass', 'custodian_c'),
        source_date_col='a.effective_at', reference_date_col='effective_at') }}
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_head_for_day
    , case
        when a._created_at = max(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_latest
    , case
        when a._created_at = min(a._created_at) over (partition by a.effective_at::date)
            then 1
        else 0
    end                                                       as is_earliest
from {{ source('salesforce_compass', 'custodian_c') }} as a
