{% set src = source('envestnet_mwa','bills') %}

select
    'envestnet'                                        as system_name
    , 'manasquan'                                      as system_instance
    , concat(system_name , '__' , system_instance)     as system_key
    , 'mwa'                                            as firm_source
    , json:"12b1 Rebate Amount"::decimal(20 , 5)       as rebate_amount
    , json:"Account Number"::text(200)                 as account_number
    , json:"Account Rep code"::text(200)               as account_rep_code
    , json:"Account Rep code.1"::text(200)             as account_rep_code_alt
    , json:"Account Title"::text(200)                  as account_title
    , json:"Account total"::decimal(20 , 5)            as account_total
    , json:"Advisor Fee"::decimal(20 , 5)              as advisor_fee
    , json:"Advisor Fee Pct"::decimal(20 , 5)          as advisor_fee_pct
    , json:"Advisor Firm"::text(200)                   as advisor_firm
    , json:"Advisor Name"::text(200)                  as advisor_name
    , json:"Advisor Num"::text(200)                    as advisor_num
    , json:"Advisor Tier"::text(200)                   as advisor_tier
    , json:"Batch Name"::text(200)                     as batch_name
    , json:"Bill Type"::text(200)                      as bill_type
    , json:"Billable Household Value"::decimal(20 , 5) as billable_household_value
    , json:"Billable days"::int                        as billable_days
    , json:"Billable value"::decimal(20 , 5)           as billable_value
    , json:"Billing Cycle"::text(200)                  as billing_cycle
    , json:"Billing Group Name"::text(200)             as billing_group_name
    , json:"Billing Level"::text(200)                  as billing_level
    , json:"Branch"::text(200)                         as branch
    , json:"Client Fee"::decimal(20 , 5)               as client_fee
    , json:"Client Fee Pct"::decimal(20 , 5)           as client_fee_pct
    , json:"Client Name"::text(200)                    as client_name
    , json:"Cust ACH"::decimal(20 , 5)                 as cust_ach
    , json:"Custodian Id"::text(200)                   as custodian_id
    , json:"Custody Fee"::decimal(20 , 5)              as custody_fee
    , json:"Custody Fee Pct"::decimal(20 , 5)          as custody_fee_pct
    , json:"Custom Service Fee"::decimal(20 , 5)       as custom_service_fee
    , json:"Custom Service Fee Pct"::decimal(20 , 5)   as custom_service_fee_pct
    , json:"Customer Rep Code"::text(200)              as customer_rep_code
    , json:"Debit Custodian"::text(200)                as debit_custodian
    , json:"Debit Type"::text(200)                     as debit_type
    , json:"Debited Account"::text(200)                as debited_account
    , json:"Enterprise"::text(200)                     as enterprise
    , json:"Envestnet Fee"::decimal(20 , 5)            as envestnet_fee
    , json:"Envestnet Fee Pct"::decimal(20 , 5)        as envestnet_fee_pct
    , json:"Firm Fee"::decimal(20 , 5)                 as firm_fee
    , json:"Firm Fee Pct"::decimal(20 , 5)             as firm_fee_pct
    , json:"GI Fee"::decimal(20 , 5)                   as gi_fee
    , json:"Group Accounts"::text(200)                 as group_accounts
    , json:"Holdback Fee"::decimal(20 , 5)             as holdback_fee
    , json:"Impact Restrictions Fee"::decimal(20 , 5)  as impact_restrictions_fee
    , json:"Invested"::date                            as invested_date
    , json:"Manager Fee"::decimal(20 , 5)              as manager_fee
    , json:"Manager Fee Pct"::decimal(20 , 5)          as manager_fee_pct
    , json:"NTF Pct"::decimal(20 , 5)                  as ntf_pct
    , json:"Period End"::date                          as period_end_date
    , json:"Period days"::int                          as period_days
    , json:"Period start"::date                        as period_start_date
    , json:"Platform Household Value"::decimal(20 , 5) as platform_household_value
    , json:"Product"::text(200)                        as product
    , json:"Product Tier"::text(200)                   as product_tier
    , json:"Product Type"::text(200)                   as product_type
    , json:"ROA Fee"::decimal(20 , 5)                  as roa_fee
    , json:"Sponsor Fee"::decimal(20 , 5)              as sponsor_fee
    , json:"Sponsor Fee Pct"::decimal(20 , 5)          as sponsor_fee_pct
    , json:"TSD Fee"::decimal(20 , 5)                  as tsd_fee
    , json:"TSD Household Value"::decimal(20 , 5)      as tsd_household_value
    , json:"Tax Mgt Fee"::decimal(20 , 5)              as tax_mgmt_fee
    , json:"Tax Overlay Fee"::decimal(20 , 5)          as tax_overlay_fee
    , _id                                              as _id
    , _created_at                                      as _created_at
    , _box_file_id::text(200)                          as _box_file_id
    , _box_file_name::text(200)                        as _box_file_name
    , _box_meta                                        as _box_meta
from {{ src }}
