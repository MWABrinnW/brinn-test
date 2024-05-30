select
    'envestnet'                                                                     as system_name
    , 'manasquan'                                                                   as system_instance
    , concat(system_name , '__' , system_instance)                                  as system_key
    , 'mwa'                                                                         as firm_source
    , json:"Account"::varchar(200)                                                  as account--noqa: RF04
    , json:"Count"::int                                                             as count
    , json:"Client"::varchar(200)                                                   as client
    , try_to_date((json:"Bill Date"::varchar(200)) , 'MON YYYY')::date              as bill_date
    , to_date(split_part(json:"Bill Period" , '-' , 1) , 'MM/DD/YY')                as bill_period_start_date
    , to_date(split_part(json:"Bill Period" , '-' , 2) , 'MM/DD/YY')                as bill_period_end_date
    , json:"Days"::int                                                              as days
    , json:"Bill Type"::varchar(200)                                                as bill_type
    , replace(json:"Billable Value" , ',' , '')::decimal(20 , 2)                    as billable_value
    , replace(json:"Program Fee" , ',' , '')::decimal(20 , 2)                       as program_fee
    , replace(json:"Program Fee%" , ',' , '')::decimal(20 , 3)                      as program_fee_pct
    , replace(json:"Manager Fee" , ',' , '')::decimal(20 , 2)                       as manager_fee
    , replace(json:"Manager Fee%" , ',' , '')::decimal(20 , 3)                      as manager_fee_pct
    , replace(json:"Manager Fee Excluded Value" , ',' , '')::decimal(20 , 2)        as manager_fee_excluded_value
    , replace(json:"Manager Fee Billable Value" , ',' , '')::decimal(20 , 2)        as manager_fee_billable_value
    , replace(json:"Advisor Fee" , ',' , '')::decimal(20 , 2)                       as advisor_fee
    , replace(json:"Advisor Fee%" , ',' , '')::decimal(20 , 3)                      as advisor_fee_pct
    , replace(json:"Advisor Fee Excluded Value" , ',' , '')::decimal(20 , 2)        as advisor_fee_excluded_value
    , replace(json:"Advisor Fee Billable Value" , ',' , '')::decimal(20 , 2)        as advisor_fee_billable_value
    , replace(json:"Client Fee" , ',' , '')::decimal(20 , 2)                        as client_fee
    , replace(json:"Client Fee%" , ',' , '')::decimal(20 , 3)                       as client_fee_pct
    , replace(json:"Client Fee Excluded Value" , ',' , '')::decimal(20 , 2)         as client_fee_excluded_value
    , replace(json:"Client Fee Billable Value" , ',' , '')::decimal(20 , 2)         as client_fee_billable_value
    , replace(json:"Principal Client Fee" , ',' , '')::decimal(20 , 2)              as principal_client_fee
    , replace(json:"Income Client Fee" , ',' , '')::decimal(20 , 2)                 as income_client_fee
    , json:"Advisor Name"::varchar(200)                                             as advisor_name
    , json:"Product Type"::varchar(200)                                             as product_type
    , json:"Advisor Tier"::varchar(200)                                             as advisor_tier
    , json:"Registration Type"::varchar(200)                                        as registration_type
    , json:"Debit Registration Type"::varchar(200)                                  as debit_registration_type
    , json:"Rep Code"::varchar(200)                                                 as rep_code
    , json:"Product Name"::varchar(200)                                             as product_name
    , json:"Debit Type"::varchar(200)                                               as debit_type
    , json:"Debit Account"::varchar(200)                                            as debit_account
    , json:"Firm"::varchar(200)                                                     as firm
    , json:"Branch"::varchar(200)                                                   as branch
    , json:"Billing Group Name"::varchar(200)                                       as billing_group_name
    , replace(json:"Excluded Assets" , ',' , '')::decimal(20 , 2)                   as excluded_assets
    , json:"Pricing Rule"::varchar(200)                                             as pricing_rule
    , replace(json:"Custody Fee" , ',' , '')::decimal(20 , 2)                       as custody_fee
    , replace(json:"Custody Fee%" , ',' , '')::decimal(20 , 3)                      as custody_fee_pct
    , replace(json:"Custody Fee Excluded Value" , ',' , '')::decimal(20 , 2)        as custody_fee_excluded_value
    , replace(json:"Custody Fee Billable Value" , ',' , '')::decimal(20 , 2)        as custody_fee_billable_value
    , replace(json:"Firm Fee" , ',' , '')::decimal(20 , 2)                          as firm_fee
    , replace(json:"Firm Fee%" , ',' , '')::decimal(20 , 3)                         as firm_fee_pct
    , replace(json:"Firm Fee Excluded Value" , ',' , '')::decimal(20 , 2)           as firm_fee_excluded_value
    , replace(json:"Firm Fee Billable Value" , ',' , '')::decimal(20 , 2)           as firm_fee_billable_value
    , replace(json:"Sponsor Fee" , ',' , '')::decimal(20 , 2)                       as sponsor_fee
    , replace(json:"Sponsor Fee%" , ',' , '')::decimal(20 , 3)                      as sponsor_fee_pct
    , replace(json:"Sponsor Fee Excluded Value" , ',' , '')::decimal(20 , 2)        as sponsor_fee_excluded_value
    , replace(json:"Sponsor Fee Billable Value" , ',' , '')::decimal(20 , 2)        as sponsor_fee_billable_value
    , replace(json:"Platform Fee" , ',' , '')::decimal(20 , 2)                      as platform_fee
    , replace(json:"Platform Fee%" , ',' , '')::decimal(20 , 3)                     as platform_fee_pct
    , replace(json:"Platform Fee Excluded Value" , ',' , '')::decimal(20 , 2)       as platform_fee_excluded_value
    , replace(json:"Platform Fee Billable Value" , ',' , '')::decimal(20 , 2)       as platform_fee_billable_value
    , try_to_date((json:"Start Date"::varchar(200)) , 'MM/DD/YY')::date             as start_date
    , json:"Billing Mode"::varchar(200)                                             as billing_mode
    , json:"Billing Cycle"::varchar(200)                                            as billing_cycle
    , json:"Derived Component"::varchar(200)                                        as derived_component
    , replace(json:"Billable Household Value" , ',' , '')::decimal(20 , 2)          as billable_household_value
    , replace(json:"Platform Billable Household Value" , ',' , '')::decimal(20 , 2) as platform_billable_household_value
    , replace(json:"Account Market Value" , ',' , '')::decimal(20 , 2)              as account_market_value
    , json:"Billing History Id"::varchar(200)                                       as billing_history_id
    , json:"Debit Custodian"::varchar(200)                                          as debit_custodian
    , replace(json:"Annual Account Fee Excluded Value" , ',' , '')::decimal(20 , 2) as annual_account_fee_excluded_value
    , replace(json:"Annual Account Fee Billable Value" , ',' , '')::decimal(20 , 2) as annual_account_fee_billable_value
    , replace(json:"Small Account Fee Excluded Value" , ',' , '')::decimal(20 , 2)  as small_account_fee_excluded_value
    , replace(json:"Small Account Fee Billable Value" , ',' , '')::decimal(20 , 2)  as small_account_fee_billable_value
    , json:"Advisor Number"::varchar(200)                                           as advisor_number
    , json:"Customer Rep Code"::varchar(200)                                        as customer_rep_code
    , json:"Account Rep Code"::varchar(200)                                         as account_rep_code
    , try_to_date((json:"Created Date"::varchar(200)) , 'MM/DD/YY')::date           as created_date
    , try_to_date((json:"Published Date"::varchar(200)) , 'MM/DD/YY')::date         as published_date
    , json:"Transmitted Date"::date                                                 as transmitted_date
    , replace(json:"Client GST Rate%" , ',' , '')::decimal(20 , 3)                  as client_gst_rate_pct
    , json:"Client GST ID"::varchar(200)                                            as client_gst_id
    , replace(json:"Client GST" , ',' , '')::decimal(20 , 2)                        as client_gst
    , replace(json:"Client HST Rate%" , ',' , '')::decimal(20 , 3)                  as client_hst_rate_pct
    , json:"Client HST ID"::varchar(200)                                            as client_hst_id
    , replace(json:"Client HST" , ',' , '')::decimal(20 , 2)                        as client_hst
    , replace(json:"Client PST Rate%" , ',' , '')::decimal(20 , 3)                  as client_pst_rate_pct
    , json:"Client PST ID"::varchar(200)                                            as client_pst_id
    , replace(json:"Client PST" , ',' , '')::decimal(20 , 2)                        as client_pst
    , replace(json:"Client QST Rate%" , ',' , '')::decimal(20 , 3)                  as client_qst_rate_pct
    , json:"Client QST ID"::varchar(200)                                            as client_qst_id
    , replace(json:"Client QST" , ',' , '')::decimal(20 , 2)                        as client_qst
    , replace(json:"Unsupervised Value" , ',' , '')::decimal(20 , 2)                as unsupervised_value
    , json:"Custodian Id"::varchar(200)                                             as custodian_id
    , json:"Custodian"::varchar(200)                                                as custodian
    , json:"Debit Custodian Id"::varchar(200)                                       as debit_custodian_id
    , json:"Bill Program"::varchar(200)                                             as bill_program
    , json:"Transaction Billing Exclusion"::varchar(200)                            as transaction_billing_exclusion
    , json:"Firm CRD"::varchar(200)                                                 as firm_crd
    , json:"Firm DTCC Code"::varchar(200)                                           as firm_dtcc_code
    , _id                                                                           as _id
    , _created_at                                                                   as _created_at
    , _box_file_id::varchar(200)                                                    as _box_file_id
    , _box_file_name::varchar(200)                                                  as _box_file_name
    , _box_meta                                                                     as _box_meta
from {{ source('envestnet_mwa_raw','bills') }}
where true
    and account <> 'Totals'
