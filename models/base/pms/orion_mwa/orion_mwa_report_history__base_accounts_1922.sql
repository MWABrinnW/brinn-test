select
    'orion' as pms
    , 'mwa' as pms_location
    , 'mwa' AS firm_source
    , effective_date
    , account_id
    , account_number
    , account_start_date
    , account_status
    , acctcanceldate
    , address1
    , address2
    , address3
    , bd_name
    , bill_frequency
    , bill_start_date
    , bill_style
    , business_line
    , city
    , client_id
    , client_name
    , clientcreateddate
    , createddate
    , current_value
    , custodian
    , custodian_code
    , editeddate
    , email
    , exclude_from_cost_basis
    , fee_schedule
    , fee_type
    , first_name
    , fund_name
    , include_in_qpe
    , include_in_twr
    , investmentobjective
    , isaccountactive
    , isdiscretionary
    , ismanaged
    , isqual
    , last_name
    , lastinvoicecreationdate
    , lasttrxdate
    , master_payout_schedule
    , mgmt_style
    , mgmt_style_code
    , minimum_cash_balance
    , model_name
    , net_worth
    , pay_method_instruction
    , phone_business
    , phone_home
    , reg_description
    , reg_f_name
    , reg_l_name
    , reg_name
    , regisactive
    , registration_id
    , rep_name
    , rep_number
    , risk_tolerance
    , salutation
    , ssn
    , state
    , statement_transmit_method
    , sub_advisor_code
    , subadvisorname
    , trade_instruction
    , true_account_start_date
    , zip
    , {{ col_is_head(reference=source('orion_mwa', 'audit_all_advisors_1922_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime as _source_loaded_at
from {{ source('orion_mwa', 'audit_all_advisors_1922_history') }}