select
    'addepar'                                      as system_name
    , 'corbenic'                                   as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , upper(holding_account_number)                as account_number_formatted
    , regexp_replace(
        ltrim(upper(replace(trim(holding_account_number) , '-' , '')) , '0')::text(200)
        , '\\s{2,}' , ' '
    )::text(200)                                   as account_number
    , effective_date
    , top_level_holding_account
    , top_level_holding_account_entity_id
    , top_level_account_number
    , holding_account
    , holding_account_entity_id
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
    , case
        when upper(trim(cwm_lead_advisor)) = 'BG'
            then 'Brad Griswold'
        when upper(trim(cwm_lead_advisor)) = 'DG'
            then 'David Givler II'
        when upper(trim(cwm_lead_advisor)) = 'MB'
            then 'Mark Borda'
        when upper(trim(cwm_lead_advisor)) = 'WV'
            then 'William Velekei'
        when upper(trim(cwm_lead_advisor)) = 'HA'
            then 'House Account'
    end                                            as client_manager
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
    , _id                                          as _id
    , record_datetime                              as _created_at
    , source_file                                  as _source_file
    -- remove after Alteryx workflows are retired for accounts and holdings masters
    , holding_account_number
from {{ source('addepar_corbenic', 'accounts') }}
