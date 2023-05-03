
select
    'lpl'                                      as custodian
  , subscriberid::varchar(5)                   as subscriber_id
  , case
        when subscriberid::varchar(5) in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                       as firm_source
  , accountid::text(100)                       as account_id
  , clientid::text(100)                        as client_id
  , lplaccountno::text(100)                    as account_number
  , sponsorname::varchar(100)                  as sponsor_name
  , sponsoraccountno::text(100)                as sponsor_account_no
  , accountclasscode::varchar(10)              as account_class_code
  , institutioncode::varchar(1)                as institution_code
  , repid::varchar(5)                          as rep_id
  , repssn::varchar(11)                        as rep_ssn
  , repname::varchar(100)                      as rep_name
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
  , ddano::text(100)                           as ddano
  , registrationline2::text(100)               as registration_line_2
  , registrationline3::text(100)               as registration_line_3
  , registrationline4::text(100)               as registration_line_4
  , registrationline5::text(100)               as registration_line_5
  , registrationline6::text(100)               as registration_line_6
  , registrationline7::text(100)               as registration_line_7
  , homephoneno::int                           as home_phone_no
  , businessphoneno::int                       as business_phone_no
  , faxno::int                                 as fax_no
  , mobilephoneno::text(100)                   as mobile_phone_no
  , emailaddress::text(100)                    as email_address
  , feeschedule::text(100)                     as fee_schedule
  , opennotificationcount::int                 as open_notification_count
  , booksandrecordsstatus::text(100)           as books_and_record_status
  , accountnickname::text(100)                 as account_nickname
  , secondaryrepid::text(100)                  as secondary_rep_id
  , referralrepid::text(100)                   as referral_rep_id
  , accountmarketvalue::text(100)              as account_market_value
  , networkedaccountmarketvalue::text(100)     as networked_account_market_value
  , accountlocationcode::text(100)             as account_location_code
  , accountsocialcode::text(100)               as account_social_code
  , investmentobjectivecode::text(100)         as investment_objective_code
  , annualincomecode::text(100)                as annual_income_code
  , networthcode::text(100)                    as networth_code
  , liquidnetworthcode::text(100)              as liquid_networth_code
  , approximateaccountvaluecode::text(100)     as approximate_account_value_code
  , proceedsinstructionscode::text(100)        as proceeds_instructions_code
  , securityinstructioncode::text(100)         as security_instruction_code
  , dividendsinstructioncode::text(100)        as dividends_instruction_code
  , dividendreinvestinstructioncode::text(100) as dividen_reinvest_instruction_code
  , iscostbasisonstatements::int               as is_cost_basis_on_statements
  , w9statuscode::text(100)                    as w9_status_code
  , optionlevelcode::text(100)                 as option_level_code
  , oldaccountno::text(100)                    as old_account_no
  , to_date(accountmodifieddate, 'MM/DD/YYYY') as account_modified_date
  , commissionaccountno::text(100)             as commission_account_no
  , clientisssn::text(100)                     as client_isssn
  , sponsorcode::text(100)                     as sponsor_code
  , cusip::text(100)                           as cusip
  , issuppressed::int                          as is_suppressed
  , erisa::text(100)                           as erisa
  , timehorizon::text(100)                     as time_horizon
  , institutiontype::text(100)                 as institution_type
  , employeeclasscode::text(100)               as employee_class_code
  , accountclassificationcode::text(100)       as account_classification_code
  , mktg_opt_out::text(100)                    as marketing_opt_out
  , {{ col_is_head(reference=source('lpl_network', 'accountext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                       as effective_date
  , _created_at::timestamp                     as _source_loaded_at
  , _source_file::varchar(255)                 as _source_file
from {{ source('lpl_network', 'accountext') }}
