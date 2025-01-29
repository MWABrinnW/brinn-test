select
    'orion'                                        as system_name
    , 'mwa'                                        as system_instance
    , concat(system_name , '__' , system_instance) as system_key
    , 'mwa'                                        as firm_source
    , effective_date
    , account_id
    , accountstatus
    , accountvalue
    , accruedint
    , acct_is_managed
    , acctcode
    , acctstartdate
    , addr1
    , addr2
    , asofdate
    , broker_dealer_name
    , businesslinename
    , canceldate
    , canceldate1
    , city
    , client_id
    , client_name
    , clientaddress
    , clientaddress2
    , clientcity
    , clientemail
    , clientzip
    , feeschedule
    , fund_name
    , include_in_qpe
    , include_in_twr
    , isactive
    , isannuity
    , isqualified
    , lname
    , mgmt_style
    , model_name
    , outsideid
    , pay_method
    , payoutschedule
    , planname
    , plannumber
    , recondate
    , reg_description
    , reg_id
    , reg_name
    , rep_name
    , repno
    , ssn_taxid
    , startdate
    , state
    , subadvisorname
    , totalaccountvalue
    , zip
    , {{ col_is_head(reference=source('orion_mwa', 'as_of_value_by_account_6473_history')) }}
    , {{ col_is_current(date_col='effective_date') }}
    , record_datetime                              as _source_loaded_at
from {{ source('orion_mwa', 'as_of_value_by_account_6473_history') }}
