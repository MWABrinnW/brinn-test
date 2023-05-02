SELECT
    'addepar' as pms
    , 'corbenic' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , top_level_holding_account
    , top_level_holding_account_entity_id
    , top_level_account_number
    , holding_account
    , holding_account_entity_id
    , holding_account_number
    , top_level_owner
    , top_level_owner_entity_id
    , top_level_owner_id
    , inception_date
    , value
    , accrued_income
    , cwm_custodian
    , cwm_account_type
    , cwm_strategy
    , cwm_lead_advisor
    , cwm_service_advisor
    , cwm_non_discretionary
    , cwm_closed_date
    , cwm_closed_account
    , bill_fee_schedule
    , fee_schedule_legacy
    , bill_fee_schedule_description
    , bill_fee_type
    , billing_payment_method
    , bill_to_account_number
    , exclude_from_billing
    , view_id
    , job_id
    , source_file
    , cwm_line_of_business
    , cwm_erisa_account
    , {{ col_is_head(reference=source('addepar_corbenic', 'accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
FROM {{ source('addepar_corbenic', 'accounts') }}
