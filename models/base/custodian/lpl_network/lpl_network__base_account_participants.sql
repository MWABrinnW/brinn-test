
select
    'lpl'                                                   as custodian
  , regexp_substr(_source_file, 'DFM-(.{4})-.*', 1, 1, 'e') as subscriber_id
  , case
        when subscriber_id in ('R5TC','42LN','7PCM','86JN','86YM','G44R','G9CN','H01M','LH7H','V0TK')
            THEN 'swag'
        else
            'network'
        end::varchar(50)                                    as firm_source
  , accountid::int                                          as account_id
  , lplaccountno::int                                       as lpl_account_no
  , repid::text(100)                                        as rep_id
  , firstname::text(100)                                    as first_name
  , middlename::text(100)                                   as middle_name
  , lastname::text(100)                                     as last_name
  , ssntin::text(100)                                       as ssn_tin
  , try_to_date(birthdate, 'MM/DD/YYYY')                    as birth_date
  , accountrole::text(100)                                  as account_role
  , idno::text(100)                                         as id_no
  , idplaceofissue::text(100)                               as id_place_of_issue
  , employername::text(100)                                 as employer_name
  , try_to_number(isemployeeindustryaffiliation)::int       as is_employee_industry_affililation
  , employerindustry::text(100)                             as employer_industry
  , corpaffiliation::text(100)                              as corp_affiliation
  , occupation::text(100)                                   as occupation
  , employeraddress1::text(100)                             as employer_address_1
  , employeraddress2::text(100)                             as employer_address_2
  , employeraddress3::text(100)                             as employer_address_3
  , employercity::text(100)                                 as employer_city
  , employerstate::text(100)                                as employer_state
  , employerprovince::text(100)                             as employer_province
  , employerzipcode::text(100)                              as employer_zip_code
  , employerforeignzipcode::text(100)                       as employer_foreign_zip_code
  , employerphonecountrycode::text(100)                     as employer_phone_country_code
  , employerphonecitycode::text(100)                        as employer_phone_city_code
  , employerphonephoneno::text(100)                         as employer_phone_phone_no
  , employercountry::text(100)                              as employer_country
  , customeraddress1::text(100)                             as customer_address_1
  , customeraddress2::text(100)                             as customer_address_2
  , customeraddress3::text(100)                             as customer_address_3
  , customercity::text(100)                                 as customer_city
  , customerstate::text(100)                                as customer_state
  , customerprovince::text(100)                             as customer_province
  , customerzipcode::text(100)                              as customer_zip_code
  , customerforeignzipcode::text(100)                       as customer_foreign_zip_code
  , homephonecountrycode::text(100)                         as home_phone_country_code
  , homephonecitycode::text(100)                            as home_phone_city_code
  , homephonephoneno::text(100)                             as home_phone_phone_no
  , customercountry::text(100)                              as customer_country
  , isssn::text(100)                                        as is_ssn
  , accounttype::text(100)                                  as account_type
  , accountfeebased::text(100)                              as account_fee_based
  , risktolerance::text(100)                                as risk_tolerance
  , entityincome::text(100)                                 as entity_income
  , entitystatecode::text(100)                              as entity_state_code
  , entitytaxbracket::text(100)                             as entity_tax_bracket
  , accountplantype::text(100)                              as account_plan_type
  , accountemployeeowned::text(100)                         as account_employee_owned
  , entitycitizenship::text(100)                            as entity_citizenship
  , customerid::text(100)                                   as customer_id
  , customertype::text(100)                                 as customer_type
  , accountregtype::text(100)                               as account_reg_type
  , customergovtidtype::text(100)                           as customer_govt_id_type
  , customergovtidissuedate::text(100)                      as customer_govt_issue_date
  , customergovtidexpdate::text(100)                        as customer_vot_id_exp_date
  , try_to_date(customerdeathdate, 'MM/DD/YYYY')            as customer_death_date
  , firm_id                                                 as firm_id
  , {{ col_is_head(reference=source('lpl_network', 'accountparticipantext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                                    as effective_date
  , _created_at::timestamp                                  as _source_loaded_at
  , _source_file                                            as _source_file
from {{ source('lpl_network', 'accountparticipantext') }}