{% set src = source('black_diamond_houston', 'bills') %}

select
    'black_diamond'                                                  as system_name
    , 'houston'                                                      as system_instance
    , concat(system_name , '__' , system_instance)                   as system_key
    , 'mwa'                                                          as firm_source
    , json:"Status"::varchar(200)                                    as status
    , json:"Account Number"::varchar(200)                            as account_number
    , json:"Account Name"::varchar(200)                              as account_name
    , json:"Workflow"::varchar(200)                                  as workflow
    , json:"Portfolio Group"::varchar(200)                           as portfolio_group
    , json:"Portfolio Name"::varchar(200)                            as portfolio_name
    , json:"Portfolio Display Name"::varchar(200)                    as portfolio_display_name
    , json:"Rep Code"::varchar(200)                                  as rep_code
    , json:"Rep Name (If Available)"::varchar(200)                   as rep_name
    , json:"Fee Schedule Name"::varchar(200)                         as fee_schedule_name
    , json:"Billing Configuration Name"::varchar(200)                as billing_configuration_name
    , json:"Billing Start Date"::date                                as billing_start_date
    , json:"Billing Closed Date"::date                               as billing_closed_date
    , json:"As of Date"::date                                        as as_of_date
    , json:"Billable Status"::varchar(200)                           as billable_status
    , json:"Billing Account Number"::varchar(200)                    as billing_account_number
    , json:"Billing Account Name"::varchar(200)                      as billing_account_name
    , json:"Billing Account Custodian"::varchar(200)                 as billing_account_custodian
    , json:"Custodian"::varchar(200)                                 as custodian
    , json:"Goal"::varchar(200)                                      as goal
    , json:"Manager"::varchar(200)                                   as manager
    , json:"Style"::varchar(200)                                     as style
    , json:"Relationship"::varchar(200)                              as relationship
    , json:"Flow Date (Cash Flows)"::varchar(200)                    as flow_date_cash_flows
    , json:"Flow Day Count (Cash Flows)"::varchar(200)               as flow_day_count_cash_flows
    , json:"Contributions Withdrawals (Cash Flows)"::decimal(20 , 5) as contributions_withdrawals_cash_flows
    , json:"Days Held"::int                                          as days_held
    , json:"Days Not Held (Closed Rebates)"::int                     as days_not_held_closed_rebates
    , json:"E/C Amount"::decimal(20 , 5)                             as ec_amount
    , json:"E/C Return Date"::datetime                               as ec_return_date
    , json:"E/C Period End Date"::datetime                           as ec_period_end_date
    , json:"E/C Description"::varchar(200)                           as ec_description
    , json:"Account Value"::decimal(20 , 2)                          as account_value
    , json:"Rate Value"::decimal(20 , 2)                             as rate_value
    , json:"Billed Value"::decimal(20 , 2)                           as billed_value
    , (json:"Rate (bps)"::decimal(20 , 8) / 10000)                   as rate_percentage
    , json:"Rate (bps)"::decimal(20 , 8)                             as rate_bps
    , json:"Fee or Rebate Amount"::decimal(20 , 2)                   as fee_or_rebate_amount
    , json:"Total Period Fee"::decimal(20 , 2)                       as total_period_fee
    , json:"Cash Available"::decimal(20 , 2)                         as cash_available
    , json:"Days in Period"::int                                     as days_in_period
    , json:"Assignment Level"::varchar(200)                          as assignment_level
    , json:"Cash Difference"::decimal(20 , 2)                        as cash_difference
    , json:"Assigned To"::varchar(200)                               as assigned_to
    , json:"Cash Available Date"::date                               as cash_available_date
    , json:"Billing Rule Applied"::varchar(200)                      as billing_rule_applied
    , json:"External ID"::varchar(200)                               as external_id
    , json:"Start Date Adj EMV"::decimal(20 , 2)                     as start_date_adj_emv
    , json:"Close Date Adj BMV"::decimal(20 , 2)                     as close_date_adj_bmv
    , json:"Last Job ID"::varchar(200)                               as last_job_id
    , json:"Last As of Date"::date                                   as last_as_of_date
    , json:"Last Billed Value"::decimal(20 , 2)                      as last_billed_value
    , json:"Billed Value Change (%)"::decimal(20 , 4)                as billed_value_change_percentage
    , json:"Last Fee/Rebate Amount"::decimal(20 , 2)                 as last_fee_rebate_amount
    , json:"Fee/Rebate Change (%)"::decimal(20 , 4)                  as fee_rebate_change_percentage
    , json:"Other Billing Method"::varchar(200)                      as other_billing_method
    , json:"Assignment Notes"::varchar(200)                          as assignment_notes
    , json:"Account Long Name"::varchar(200)                         as account_long_name
    , json:"Billing Account Long Name"::varchar(200)                 as billing_account_long_name
    , json:"Finalized Date"::date                                    as finalized_date
    , json:"Finalized By"::varchar(200)                              as finalized_by
    , json:"Preferential Retirement"::varchar(200)                   as preferential_retirement
    , json:"Account State"::varchar(200)                             as account_state
    , json:"Breakpoint Portfolio Name"::varchar(200)                 as breakpoint_portfolio_name
    , json:"Breakpoint Relationship Name"::varchar(200)              as breakpoint_relationship_name
    , json:"Period End Date"::date                                   as period_end_date
    , json:"Account Registration"::varchar(200)                      as account_registration
    , json:"Lot"::varchar(200)                                       as lot
    , json:"MWA Contract"::varchar(200)                              as mwa_contract
    , json:"Notes"::varchar(200)                                     as notes
    , json:"PB"::varchar(200)                                        as pb
    , json:"QB"::varchar(200)                                        as qb
    , json:"R"::varchar(200)                                         as r
    , json:"Regulatory Account"::varchar(200)                        as regulatory_account
    , json:"Rest Notes"::varchar(200)                                as rest_notes
    , json:"SAN Account"::varchar(200)                               as san_account
    , json:"SI Custody"::varchar(200)                                as si_custody
    , json:"State"::varchar(200)                                     as state
    , json:"State2"::varchar(200)                                    as state2
    , json:"Stonnington Referral"::varchar(200)                      as stonnington_referral
    , json:"Strategy"::varchar(200)                                  as strategy
    , json:"TD Account Number"::varchar(200)                         as td_account_number
    , json:"TR"::varchar(200)                                        as tr
    , json:"WAS Account"::varchar(200)                               as was_account
    , json:"ADV 5D - Client Type"::varchar(200)                      as adv_5d_client_type
    , json:"Manager Name (Invoices)"::varchar(200)                   as manager_name_invoices
    , json:"Notes"::varchar(200)                                     as additional_notes
    , json:"Warnings"::varchar(200)                                  as warnings
    , {{ col_is_head_with_partition(reference=src
        , partition_col = '_box_file_name'
        , reference_date_col='_created_at'
        , source_date_col='_created_at') }}
    , _created_at::datetime                                          as _created_at
    , _box_file_id::text(200)                                        as _box_file_id
    , _box_meta::variant                                             as _box_meta
    , _box_file_name::varchar(200)                                   as _box_file_name
    , _id::int                                                       as _id
from {{ src }}
