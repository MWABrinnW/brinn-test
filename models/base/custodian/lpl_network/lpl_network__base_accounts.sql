
select
    accountid::int                             as account_id
  , clientid::int                              as client_id
  , lplaccountno::int                          as lpl_account_no
  , sponsorname::varchar(100)                  as sponsor_name
  , sponsoraccountno::int                      as sponsor_account_no
  , accountclasscode::varchar(10)              as account_class_code
  , institutioncode::varchar(1)                as institution_code
  , repid::varchar(5)                          as rep_id
  , repssn::varchar(11)                        as rep_ssn
  , repname::varchar(100)                      as rep_name
  , subscriberid::varchar(5)                   as subscriber_id
  , subscribername::varchar(100)               as subscriber_name
  , fisbranchid::varchar(50)                   as fis_branch_id
  , fisbranchname::varchar(100)                as fis_branch_name
  , clientssntin::varchar(11)                  as client_ssn_tin
  , accountname::varchar(100)                  as account_name
  , registrationline1::varchar(100)            as registration_line_1
  , registrationcity::varchar(100)             as registrationcity
  , registrationstate::varchar(100)            as registrationstate
  , registrationzipcode::varchar(100)          as registrationzipcode
  , registrationcountry::varchar(100)          as registrationcountry
  , to_date(opendate, 'MM/DD/YYYY')            as open_date
  , to_date(closedate, 'MM/DD/YYYY')           as close_date
  , ddano::int                                 as ddano
  , registrationline2                          as registration_line_2
  , registrationline3                          as registration_line_3
  , registrationline4                          as registration_line_4
  , registrationline5                          as registration_line_5
  , registrationline6                          as registration_line_6
  , registrationline7                          as registration_line_7
  , homephoneno::int                           as home_phone_no
  , businessphoneno::int                       as business_phone_no
  , faxno::int                                 as fax_no
  , mobilephoneno::int                         as mobile_phone_no
  , emailaddress                               as email_address
  , feeschedule                                as fee_schedule
  , opennotificationcount::int                 as open_notification_count
  , booksandrecordsstatus                      as books_and_record_status
  , accountnickname                            as account_nickname
  , secondaryrepid                             as secondary_rep_id
  , referralrepid                              as referral_rep_id
  , accountmarketvalue                         as account_market_value
  , networkedaccountmarketvalue                as networkd_account_market_value
  , accountlocationcode                        as account_location_code
  , accountsocialcode                          as account_social_code
  , investmentobjectivecode                    as investment_objective_code
  , annualincomecode                           as annual_income_code
  , networthcode                               as networth_code
  , liquidnetworthcode                         as liquid_networth_code
  , approximateaccountvaluecode                as approximate_account_value_code
  , proceedsinstructionscode                   as proceeds_instructions_code
  , securityinstructioncode                    as security_instruction_code
  , dividendsinstructioncode                   as dividends_instruction_code
  , dividendreinvestinstructioncode            as dividen_reinvest_instruction_code
  , iscostbasisonstatements::int               as is_cost_basis_on_statements
  , w9statuscode                               as w9_status_code
  , optionlevelcode                            as option_level_code
  , oldaccountno                               as old_account_no
  , to_date(accountmodifieddate, 'MM/DD/YYYY') as account_modified_date
  , commissionaccountno                        as commission_account_no
  , clientisssn                                as client_isssn
  , sponsorcode                                as sponsor_code
  , cusip                                      as cusip
  , issuppressed::int                          as is_suppressed
  , erisa                                      as erisa
  , timehorizon                                as time_horizon
  , institutiontype                            as institution_type
  , employeeclasscode                          as employee_class_code
  , accountclassificationcode                  as account_classification_code
  , mktg_opt_out                               as marketing_opt_out
  , {{ col_is_head(reference=source('lpl_network', 'accountext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                       as effective_date
  , _created_at::timestamp                     as _created_at
  , _source_file::varchar(255)                 as _source_file
from {{ source('lpl_network', 'accountext') }}
