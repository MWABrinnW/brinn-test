select
    json:"Account Long Name"::text(200)               as account_long_name
    , json:"Account Name"::text(200)                  as account_name
    , json:"Account Number"::text(200)                as account_number
    , json:"Account State"::text(200)                 as account_state
    , json:"Account Value"::decimal(22 , 5)           as account_value
    , json:"Actual Client Data"::text(200)            as actual_client_data
    , json:"As of Date"::date                         as as_of_date
    , json:"Assigned To"::text(200)                   as assigned_to
    , json:"Assignment Level"::text(200)              as assignment_level
    , json:"Billable Status"::text(200)               as billable_status
    , json:"Billed Value"::decimal(22 , 5)            as billed_value
    , json:"Billed Value Change (%)"::decimal(22 , 5) as billed_value_change
    , json:"Billing Account Custodian"::text(200)     as billing_account_custodian
    , json:"Billing Account Long Name"::text(200)     as billing_account_long_name
    , json:"Billing Account Name"::text(200)          as billing_account_name
    , json:"Billing Account Number"::text(200)        as billing_account_number
    , json:"Billing Configuration Name"::text(200)    as billing_configuration_name
    , json:"Billing Rule Applied"::text(200)          as billing_rule_applied
    , json:"Billing Start Date"::date                 as billing_start_date
    , json:"Cash Available"::decimal(22 , 5)          as cash_available
    , json:"Cash Available Date"::date                as cash_available_date
    , json:"Cash Difference"::decimal(22 , 5)         as cash_difference
    , json:"Client ID"::text(200)                     as client_id
    , json:"Custodian"::text(200)                     as custodian
    , json:"Days in Period"::int                      as days_in_period
    , json:"External ID"::text(200)                   as external_id
    , json:"Fee Schedule Name"::text(200)             as fee_schedule_name
    , json:"Fee or Rebate Amount"::decimal(22 , 5)    as fee_or_rebate_amount
    , json:"Fee/Rebate Change (%)"::decimal(22 , 5)   as fee_rebate_change
    , json:"Finalized By"::text(200)                  as finalized_by
    , json:"Finalized Date"::date                     as finalized_date
    , json:"Last As of Date"::date                    as last_as_of_date
    , json:"Last Billed Value"::decimal(22 , 5)       as last_billed_value
    , json:"Last Fee/Rebate Amount"::decimal(22 , 5)  as last_fee_rebate_amount
    , json:"Last Job ID"::text(200)                   as last_job_id
    , json:"Name"::text(200)                          as name
    , json:"Period End Date"::date                    as period_end_date
    , json:"Portfolio Display Name"::text(200)        as portfolio_display_name
    , json:"Portfolio Group"::text(200)               as portfolio_group
    , json:"Portfolio Name"::text(200)                as portfolio_name
    , json:"Preferential Retirement"::text(200)       as preferential_retirement
    , json:"Rate (%)"::decimal(22 , 5)                as rate_percentage
    , json:"Rate (bps)"::decimal(22 , 5)              as rate_bps
    , json:"Rate Value"::decimal(22 , 5)              as rate_value
    , json:"Relationship"::text(200)                  as relationship
    , json:"Rep Code"::text(200)                      as rep_code
    , json:"Start Date Adj EMV"::text(200)            as start_date_adj_emv
    , json:"Total Period Fee"::decimal(22 , 5)        as total_period_fee
    , json:"Workflow"::text(200)                      as workflow
    , _created_at::timestamp_ntz                      as _created_at
    , _box_file_id::text(100)                         as _box_file_id
    , _box_file_name::text(200)                       as _box_file_name
from {{ source('aux','rev_black_diamond_mcgervey') }}
