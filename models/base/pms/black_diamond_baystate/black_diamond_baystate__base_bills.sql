select
    'black_diamond'                                      as system_name
    , 'baystate'                                         as system_instance
    , concat(system_name , '__' , system_instance)       as system_key
    , 'baystate'                                         as firm_source
    , json:"Account Long Name"::varchar(200)             as account_long_name
    , json:"Account Name"::varchar(200)                  as account_name
    , json:"Account Number"::varchar(200)                as account_number
    , json:"Account State"::varchar(200)                 as account_state
    , json:"Account Value"::number(20 , 5)               as account_value
    , json:"Advisor Commission Split Code"::varchar(200) as advisor_commission_split_code
    , json:"As of Date"::date                            as as_of_date
    , json:"Assigned To"::varchar(200)                   as assigned_to
    , json:"Assignment Level"::varchar(200)              as assignment_level
    , json:"Billable Status"::varchar(200)               as billable_status
    , json:"Billed Value"::number(20 , 5)                as billed_value
    , json:"Billed Value Change (%)"::number(20 , 5)     as billed_value_change_percentage
    , json:"Billing Account Custodian"::varchar(200)     as billing_account_custodian
    , json:"Billing Account Long Name"::varchar(200)     as billing_account_long_name
    , json:"Billing Account Name"::varchar(200)          as billing_account_name
    , json:"Billing Account Number"::varchar(200)        as billing_account_number
    , json:"Billing Configuration Name"::varchar(200)    as billing_configuration_name
    , json:"Billing Rule Applied"::varchar(200)          as billing_rule_applied
    , json:"Billing Start Date"::date                    as billing_start_date
    , json:"Cash Available"::number(20 , 5)              as cash_available
    , json:"Cash Available Date"::date                   as cash_available_date
    , json:"Cash Difference"::number(20 , 5)             as cash_difference
    , json:"Custodian"::varchar(200)                     as custodian
    , json:"Days Held"::varchar(200)                     as days_held
    , json:"Days in Period"::varchar(200)                as days_in_period
    , json:"External ID"::varchar(200)                   as external_id
    , json:"Fee Schedule Name"::varchar(200)             as fee_schedule_name
    , json:"Fee or Rebate Amount"::number(20 , 5)        as fee_or_rebate_amount
    , json:"Fee/Rebate Change (%)"::number(20 , 5)       as fee_rebate_change_percentage
    , json:"Last as of Date"::date                       as last_as_of_date
    , json:"Last Billed Value"::number(20 , 5)           as last_billed_value
    , json:"Last Fee/Rebate Amount"::number(20 , 5)      as last_fee_rebate_amount
    , json:"Last Job ID"::varchar(200)                   as last_job_id
    , json:"Manager"::varchar(200)                       as manager
    , json:"Period End Date"::date                       as period_end_date
    , json:"Preferential Retirement"::varchar(200)       as preferential_retirement
    , json:"Rate (%)"::number(20 , 5)                    as rate_percentage
    , json:"Rate (bps)"::number(20 , 5)                  as rate_bps
    , json:"Rate Value"::number(20 , 5)                  as rate_value
    , json:"Rep Code"::varchar(200)                      as rep_code
    , json:"Rep Name"::varchar(200)                      as rep_name
    , json:"Start Date Adj EMV"::varchar(200)            as start_date_adj_emv
    , json:"Status"::varchar(200)                        as status
    , json:"Style"::varchar(200)                         as style
    , json:"Total Period Fee"::number(20 , 5)            as total_period_fee
    , json:"Workflow"::varchar(200)                      as workflow
    , _id::int                                           as _id
    , _created_at::datetime                              as _created_at
    , _box_file_id::varchar(200)                         as _box_file_id
    , _box_file_name::varchar(200)                       as _box_file_name
    , _box_meta::variant                                 as _box_meta
from {{ source('black_diamond_baystate_raw', 'bills') }}
