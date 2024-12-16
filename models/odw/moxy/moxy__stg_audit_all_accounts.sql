select
    client_id
    , registration_id
    , account_id
    , first_name
    , last_name
    , client_name
    , reg_name
    , rep_name
    , rep_number
    , address1
    , address2
    , address3
    , city
    , state
    , zip
    , email
    , phone_home
    , phone_business
    , statement_transmit_method
    , reg_description
    , fund_name
    , account_number
    , mgmt_style
    , fee_schedule
    , fee_type
    , master_payout_schedule
    , pay_method_instruction
    , bill_frequency
    , bill_style
    , custodian
    , outside_id
    , subadvisorname
    , is_performance_billed
    , last_performance_bill_date
    , createddate::timestamp                      as createddate
    , editeddate::timestamp                       as editeddate
    , investmentobjective
    , planname
    , plansponsor
    , planadministratorname
    , account_start_date::timestamp               as account_start_date
    , bill_start_date::timestamp                  as bill_start_date
    , fkplan
    , current_value::number(19 , 6)               as current_value
    , pkacct_that_does_paying
    , percent_paid_by_account
    , acct_value_that_does_paying::number(19 , 6) as acct_value_that_does_paying
    , acct_no_that_does_paying
    , time_horizon
    , return_objective
    , stock_percentage
    , risk_tolerance
    , model_name
    , bd_name
    , valuation_method
    , credit_remaining::number(19 , 6)            as credit_remaining
    , salutation
    , net_worth
    , cycle_month
    , isqual::boolean                             as isqual
    , trade_instruction
    , business_line
    , custodian_code
    , plan_number
    , mgmt_style_code
    , sub_advisor_code
    , additional_charge_credit_amount
    , additional_charge_credit_type
    , model_group_num
    , minimum_inception_date::date                as minimum_inception_date
    , true_account_start_date::timestamp          as true_account_start_date
    , reponsible_party
    , account_status
    , include_in_qpe::boolean                     as include_in_qpe
    , include_in_twr
    , billingnonmgdacctno
    , billingnonmgdacctname
    , billingnonmgdclient
    , ssn
    , isaccountactive::boolean                    as isaccountactive
    , branchid
    , clientcreateddate::timestamp                as clientcreateddate
    , lasttrxdate::timestamp                      as lasttrxdate
    , lastinvoicecreationdate::timestamp          as lastinvoicecreationdate
    , fkaccounthistory
    , team
    , outside_id_household
    , outside_third_party
    , introducers_wholesalers
    , payout_anniversary_date::date               as payout_anniversary_date
    , cancel_date::timestamp                      as cancel_date
    , household_close_date::timestamp             as household_close_date
    , keep_open
    , ismanaged::boolean                          as ismanaged
    , recondate
    , source
    , householdstartdate::timestamp               as householdstartdate
    , other_mgrs_sec_number
    , record_datetime::timestamp                  as record_datetime
    , record_date::date                           as record_date
from {{ source('moxy', 'audit_all_accounts') }}
where record_datetime = (select max(record_datetime) from {{ source('moxy', 'audit_all_accounts') }})
