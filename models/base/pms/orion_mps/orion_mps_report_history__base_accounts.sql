select
    'orion'                                        as system_name
    , 'mps'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mps'                                        as firm_source
    , effective_date
    , canceldate
    , client_id
    , client_name
    , clientaddress
    , clientaddress2
    , clientcity
    , clientzip
    , clientemail
    , reg_id
    , account_id
    , lname
    , reg_name
    , addr1
    , addr2
    , city
    , state
    , zip
    , acctcode
    , fund_name
    , asofdate
    , subadvisorname
    , accountvalue
    , accruedint
    , totalaccountvalue
    , model_name
    , feeschedule
    , payoutschedule
    , startdate
    , ssn
    , mgmt_style
    , accountstatus
    , acctstartdate
    , rep_name
    , reg_description
    , isqualified
    , isactive
    , repno
    , broker_dealer_name
    , pay_method
    , businesslinename
    , include_in_qpe
    , include_in_twr
    , outsideid
    , isannuity
    , plan_name
    , plan_number
    , acct_is_managed
    , phone_number
    , age
    , account_created_date
    , cash_balance
    , {{ col_is_head(reference=source('orion_mps', 'as_of_value_by_account_3679_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mps', 'as_of_value_by_account_3679_history') }}
