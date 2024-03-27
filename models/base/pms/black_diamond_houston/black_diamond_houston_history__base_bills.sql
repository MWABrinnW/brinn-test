{% set src = source('black_diamond_houston', 'bills') %}

select
    'black_diamond'                                   as system_name
    , 'houston'                                       as system_instance
    , concat(system_name , '__' , system_instance)    as system_key
    , 'mwa'                                           as firm_source
    , json:"ADV 5D - Client Type"::varchar(200)       as adv_5d_client_type
    , json:"Account Long Name"::varchar(200)          as account_long_name
    , json:"Account Name"::varchar(200)               as account_name
    , json:"Account Registration"::varchar(200)       as account_registration
    , json:"Account Value"::decimal(20 , 5)           as account_value
    , json:"As of Date"::datetime                     as as_of_date
    , json:"Assigned To"::varchar(200)                as assigned_to
    , json:"Assignment Level"::varchar(200)           as assignment_level
    , json:"Billable Status"::varchar(200)            as billable_status
    , json:"Billed Value"::decimal(20 , 5)            as billed_value
    , json:"Billing Account Custodian"::varchar(200)  as billing_account_custodian
    , json:"Billing Account Long Name"::varchar(200)  as billing_account_long_name
    , json:"Billing Account Name"::varchar(200)       as billing_account_name
    , json:"Billing Account Number"::varchar(200)     as billing_account_number
    , json:"Billing Configuration Name"::varchar(200) as billing_configuration_name
    , json:"Billing Rule Applied"::boolean            as billing_rule_applied
    , json:"Billing Start Date"::datetime             as billing_start_date
    , json:"Cash Available"::decimal(20 , 5)          as cash_available
    , json:"Cash Available Date"::datetime            as cash_available_date
    , json:"Cash Difference"::decimal(20 , 5)         as cash_difference
    , json:"Custodian"::varchar(200)                  as custodian
    , json:"Days Held"::int                           as days_held
    , json:"Days in Period"::int                      as days_in_period
    , json:"External ID"::varchar(200)                as external_id
    , json:"Fee Schedule Name"::varchar(200)          as fee_schedule_name
    , json:"Fee or Rebate Amount"::decimal(20 , 5)    as fee_or_rebate_amount
    , json:"Last As of Date"::datetime                as last_as_of_date
    , json:"Last Billed Value"::decimal(20 , 5)       as last_billed_value
    , json:"Last Fee/Rebate Amount"::decimal(20 , 5)  as last_fee_rebate_amount
    , json:"Last Job ID"::varchar(200)                as last_job_id
    , json:"MWA Contract"::varchar(200)               as mwa_contract
    , json:"Manager Name (Invoices)"::varchar(200)    as manager_name_invoices
    , json:"PB"::boolean                              as pb
    , json:"Period End Date"::datetime                as period_end_date
    , json:"Portfolio Display Name"::varchar(200)     as portfolio_display_name
    , json:"Portfolio Group"::varchar(200)            as portfolio_group
    , json:"Portfolio Name"::varchar(200)             as portfolio_name
    , json:"Preferential Retirement"::boolean         as preferential_retirement
    , json:"QB"::varchar(200)                         as qb
    , json:"Rate (%)"::decimal(20 , 5)                as rate_percentage
    , json:"Rate (bps)"::decimal(20 , 5)              as rate_bps
    , json:"Rate Value"::decimal(20 , 5)              as rate_value
    , json:"Regulatory Account"::boolean              as regulatory_account
    , json:"SAN Account"::boolean                     as san_account
    , json:"Start Date Adj EMV"::decimal(20 , 5)      as start_date_adj_emv
    , json:"Status"::varchar(200)                     as status
    , json:"Stonnington Referral"::boolean            as stonnington_referral
    , json:"Style"::varchar(200)                      as style
    , json:"Total Period Fee"::decimal(20 , 5)        as total_period_fee
    , json:"WAS Account"::boolean                     as was_account
    , json:"Workflow"::varchar(200)                   as workflow
    , _created_at::datetime                           as _created_at
    , _box_file_id::text(200)                         as _box_file_id
    , _box_meta::variant                              as _box_meta
    , _box_file_name::varchar(200)                    as _box_file_name

from {{ src }}
