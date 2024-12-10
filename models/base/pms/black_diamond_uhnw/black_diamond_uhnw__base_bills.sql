select
    'black_diamond'                                               as system_name
    , 'uhnw'                                                      as system_instance
    , concat(system_name , '__' , system_instance)                as system_key
    , 'mwa'                                                       as firm_source
    , json:"Account Long Name"::varchar(200)                      as account_long_name
    , json:"Account Name"::varchar(200)                           as account_name
    , json:"Account Number"::varchar(200)                         as account_number
    , json:"Account State"::varchar(200)                          as account_state
    , json:"Account Value"::number(20 , 5)                        as account_value
    , json:"Advisor Commission Split Code"::varchar(200)          as advisor_commission_split_code
    , json:"As of Date"::date                                     as as_of_date
    , json:"Assigned To"::varchar(200)                            as assigned_to
    , json:"Assignment Level"::varchar(200)                       as assignment_level
    , json:"Billable Status"::varchar(200)                        as billable_status
    , json:"Billed Value"::number(20 , 5)                         as billed_value
    , json:"Billed Value Change (%)"::number(20 , 5)              as billed_value_change_percentage
    , json:"Billing Account Custodian"::varchar(200)              as billing_account_custodian
    , json:"Billing Account Long Name"::varchar(200)              as billing_account_long_name
    , json:"Billing Account Name"::varchar(200)                   as billing_account_name
    , json:"Billing Account Number"::varchar(200)                 as billing_account_number
    , json:"Billing Configuration Name"::varchar(200)             as billing_configuration_name
    , json:"Billing Rule Applied"::varchar(200)                   as billing_rule_applied
    , json:"Billing Start Date"::date                             as billing_start_date
    , json:"Cash Available"::number(20 , 5)                       as cash_available
    , json:"Cash Available Date"::date                            as cash_available_date
    , json:"Cash Difference"::number(20 , 5)                      as cash_difference
    , json:"Custodian"::varchar(200)                              as custodian
    , json:"Days Held"::varchar(200)                              as days_held
    , json:"Days in Period"::varchar(200)                         as days_in_period
    , json:"External ID"::varchar(200)                            as external_id
    , json:"Fee Schedule Name"::varchar(200)                      as fee_schedule_name
    , json:"Fee or Rebate Amount"::number(20 , 5)                 as fee_or_rebate_amount
    , json:"Fee/Rebate Change (%)"::number(20 , 5)                as fee_rebate_change_percentage
    , json:"Last as of Date"::date                                as last_as_of_date
    , json:"Last Billed Value"::number(20 , 5)                    as last_billed_value
    , json:"Last Fee/Rebate Amount"::number(20 , 5)               as last_fee_rebate_amount
    , json:"Last Job ID"::varchar(200)                            as last_job_id
    , json:"Manager"::varchar(200)                                as manager
    , json:"Period End Date"::date                                as period_end_date
    , json:"Preferential Retirement"::varchar(200)                as preferential_retirement
    , json:"Rate (%)"::number(20 , 5)                             as rate_percentage
    , json:"Rate (bps)"::number(20 , 5)                           as rate_bps
    , json:"Rate Value"::number(20 , 5)                           as rate_value
    , json:"Rep Code"::varchar(200)                               as rep_code
    , json:"Rep Name"::varchar(200)                               as rep_name
    , json:"Start Date Adj EMV"::varchar(200)                     as start_date_adj_emv
    , json:"Status"::varchar(200)                                 as status
    , json:"Style"::varchar(200)                                  as style
    , json:"Total Period Fee"::number(20 , 5)                     as total_period_fee
    , json:"Workflow"::varchar(200)                               as workflow
    , json:"Portfolio Group"::varchar(200)                        as portfolio_group
    , json:"Portfolio Name"::varchar(200)                         as portfolio_name
    , json:"Portfolio Display Name"::varchar(200)                 as portfolio_display_name
    , json:"Rep Name (If Available)"::varchar(200)                as rep_name_if_available
    , json:"Rep Fee Split Name"::varchar(200)                     as rep_fee_split_name
    , json:"Billing Closed Date"::date                            as billing_closed_date
    , json:"Goal"::varchar(200)                                   as goal
    , json:"Team"::varchar(200)                                   as team
    , json:"Relationship"::varchar(200)                           as relationship
    , json:"Flow Date (Cash Flows)"::date                         as flow_date_cash_flows
    , json:"Flow Day Count (Cash Flows)"::varchar(200)            as flow_day_count_cash_flows
    , json:"Contributions Withdrawals (Cash Flows)"::varchar(200) as contributions_withdrawals_cash_flows
    , json:"Days Not Held (Closed Rebates)"::varchar(200)         as days_not_held_closed_rebates
    , json:"E/C Amount"::number(20 , 5)                           as ec_amount
    , json:"E/C Return Date"::date                                as ec_return_date
    , json:"E/C Period End Date"::date                            as ec_period_end_date
    , json:"E/C Description"::varchar(200)                        as ec_description
    , json:"Close Date Adj BMV"::varchar(200)                     as close_date_adj_bmv
    , json:"Last Fee/Rebate Amount"::number(20 , 5)               as last_feerebate_amount
    , json:"Fee/Rebate Change (%)"::number(20 , 5)                as feerebate_change_percentage
    , json:"Other Billing Method"::varchar(200)                   as other_billing_method
    , json:"Assignment Notes"::varchar(200)                       as assignment_notes
    , json:"Finalized Date"::date                                 as finalized_date
    , json:"Finalized By"::varchar(200)                           as finalized_by
    , json:"Breakpoint Portfolio Name"::varchar(200)              as breakpoint_portfolio_name
    , json:"Breakpoint Relationship Name"::varchar(200)           as breakpoint_relationship_name
    , json:"Account Compression"::varchar(200)                    as account_compression
    , json:"Account Status"::varchar(200)                         as account_status
    , json:"Account Type"::varchar(200)                           as account_type
    , json:"AUM / AUA / RO"::varchar(200)                         as aum_aua_ro
    , json:"Billing Split"::varchar(200)                          as billing_split
    , json:"CAIS"::varchar(200)                                   as cais
    , json:"ERISA"::varchar(200)                                  as erisa
    , json:"Exclude from Billing"::varchar(200)                   as exclude_from_billing
    , json:"IPS"::varchar(200)                                    as ips
    , json:"Managed / Non-managed"::varchar(200)                  as managed_nonmanaged
    , json:"RPP Client"::varchar(200)                             as rpp_client
    , json:"TD Account Number"::varchar(200)                      as td_account_number
    , json:"Anniversary Date"::date                               as anniversary_date
    , json:"AUM as of Termination"::varchar(200)                  as aum_as_of_termination
    , json:"ExcludeFromSalentica"::varchar(200)                   as excludefromsalentica
    , json:"Fee Type"::varchar(200)                               as fee_type
    , json:"Import to Advizr"::varchar(200)                       as import_to_advizr
    , json:"Warnings"::varchar(200)                               as warnings
    , {{ col_is_head_with_partition(reference=src
        , partition_col = '_box_file_name'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
    , _id::int                                                    as _id
    , _created_at::datetime                                       as _created_at
    , _box_file_id::varchar(200)                                  as _box_file_id
    , _box_file_name::varchar(200)                                as _box_file_name
    , _box_meta::variant                                          as _box_meta
from {{ source('black_diamond_uhnw', 'bills') }}
