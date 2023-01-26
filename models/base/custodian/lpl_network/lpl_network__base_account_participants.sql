
select
    accountid::int                           as account_id
  , lplaccountno::int                        as lpl_account_no
  , repid                                    as rep_id
  , firstname                                as first_name
  , middlename                               as middle_name
  , lastname                                 as last_name
  , ssntin                                   as ssn_tin
  , to_date(birthdate, 'MM/DD/YYYY')         as birth_date
  , accountrole                              as account_role
  , idno                                     as id_no
  , idplaceofissue                           as id_place_of_issue
  , employername                             as employer_name
  , isemployeeindustryaffiliation::int       as is_employee_industry_affililation
  , employerindustry                         as employer_industry
  , corpaffiliation                          as corp_affiliation
  , occupation                               as occupation
  , employeraddress1                         as employer_address_1
  , employeraddress2                         as employer_address_2
  , employeraddress3                         as employer_address_3
  , employercity                             as employer_city
  , employerstate                            as employer_state
  , employerprovince                         as employer_province
  , employerzipcode                          as employer_zip_code
  , employerforeignzipcode                   as employer_foreign_zip_code
  , employerphonecountrycode                 as employer_phone_country_code
  , employerphonecitycode                    as employer_phone_city_code
  , employerphonephoneno                     as employer_phone_phone_no
  , employercountry                          as employer_country
  , customeraddress1                         as customer_address_1
  , customeraddress2                         as customer_address_2
  , customeraddress3                         as customer_address_3
  , customercity                             as customer_city
  , customerstate                            as customer_state
  , customerprovince                         as customer_province
  , customerzipcode                          as customer_zip_code
  , customerforeignzipcode                   as customer_foreign_zip_code
  , homephonecountrycode                     as home_phone_country_code
  , homephonecitycode                        as home_phone_city_code
  , homephonephoneno                         as home_phone_phone_no
  , customercountry                          as customer_country
  , isssn                                    as is_ssn
  , accounttype                              as account_type
  , accountfeebased                          as account_fee_based
  , risktolerance                            as risk_tolerance
  , entityincome                             as entity_income
  , entitystatecode                          as entity_state_code
  , entitytaxbracket                         as entity_tax_bracket
  , accountplantype                          as account_plan_type
  , accountemployeeowned                     as account_employee_owned
  , entitycitizenship                        as entity_citizenship
  , customerid::int                          as customer_id
  , customertype                             as customer_type
  , accountregtype                           as account_reg_type
  , customergovtidtype                       as customer_govt_id_type
  , customergovtidissuedate::int             as customer_govt_issue_date
  , customergovtidexpdate::int               as customer_vot_id_exp_date
  , to_date(customerdeathdate, 'MM/DD/YYYY') as customer_death_date
  , {{ col_is_head(reference=source('lpl_network', 'accountparticipantext')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date::date                     as effective_date
  , _created_at::timestamp                   as _created_at
  , _source_file                             as _source_file
from {{ source('lpl_network', 'accountparticipantext') }}