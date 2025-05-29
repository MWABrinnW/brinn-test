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
    , effective_date                               as effective_date
    , top_level_holding_account                    as top_level_holding_account
    , top_level_holding_account_entity_id          as top_level_holding_account_entity_id
    , top_level_account_number                     as top_level_account_number
    , holding_account                              as holding_account
    , holding_account_entity_id                    as holding_account_entity_id
    , top_level_owner                              as top_level_owner
    , top_level_owner_entity_id                    as top_level_owner_entity_id
    , top_level_owner_id                           as top_level_owner_id
    , inception_date                               as inception_date
    , value                                        as value
    , accrued_income                               as accrued_income
    , cwm_custodian                                as cwm_custodian
    , cwm_account_type                             as cwm_account_type
    , cwm_strategy                                 as cwm_strategy
    , cwm_lead_advisor                             as cwm_lead_advisor
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
    , cwm_service_advisor                          as cwm_service_advisor
    , cwm_non_discretionary                        as cwm_non_discretionary
    , cwm_closed_date                              as cwm_closed_date
    , cwm_closed_account                           as cwm_closed_account
    , bill_fee_schedule                            as bill_fee_schedule
    , fee_schedule_legacy                          as fee_schedule_legacy
    , bill_fee_schedule_description                as bill_fee_schedule_description
    , bill_fee_type                                as bill_fee_type
    , billing_payment_method                       as billing_payment_method
    , bill_to_account_number                       as bill_to_account_number
    , exclude_from_billing                         as exclude_from_billing
    , view_id                                      as view_id
    , job_id                                       as job_id
    , source_file                                  as source_file
    , cwm_line_of_business                         as cwm_line_of_business
    , cwm_erisa_account                            as cwm_erisa_account
    , {{ col_is_head(reference=source('addepar_corbenic', 'accounts')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , _id                                          as _id
    , record_datetime                              as _created_at
    , source_file                                  as _source_file
    -- remove after Alteryx workflows are retired for accounts and holdings masters
    , holding_account_number                       as holding_account_number
from {{ source('addepar_corbenic', 'accounts') }}
