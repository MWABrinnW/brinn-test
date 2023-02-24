{%- macro fidelity_nabase_2x0_customer(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                             as RECORD_TYPE
  , RECORD_NUMBER                                           as RECORD_NUMBER
  , FIRM                                                    as FIRM
  , BRANCH                                                  as BRANCH
  , ACCOUNT_NUMBER                                          as ACCOUNT_NUMBER
  , FFR_XREF                                                as FFR_XREF
  , MAIL_CODE                                               as MAIL_CODE
  , LEGAL_CODE                                              as LEGAL_CODE
  , AFF_CODE                                                as AFF_CODE
  , DAY_TEL_CODE                                            as DAY_TEL_CODE
  , NTE_TEL_CODE                                            as NTE_TEL_CODE
  , BOOK_NAME_COUNT                                         as BOOK_NAME_COUNT
  , CUST_STATE_ID                                           as CUST_STATE_ID
  , CUST_STATE_ID_TYPE                                      as CUST_STATE_ID_TYPE
  , CUST_STATE_ISSUED                                       as CUST_STATE_ISSUED
  , BROKER_AFFILIATION_CODE                                 as BROKER_AFFILIATION_CODE
  , EMPLOYEE_OCCUPATION                                     as EMPLOYEE_OCCUPATION
  , CITIZEN_ORGANIZATION_COUNTRY                            as CITIZEN_ORGANIZATION_COUNTRY
  , case
        when nvl(LAST_MAINT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_MAINT_DATE, 'YYYYMMDD') end::date as LAST_MAINT_DATE
  , UPDATE_USER_1                                           as UPDATE_USER_1
  , UPDATE_TIME_STAMP_1                                     as UPDATE_TIME_STAMP_1
  , NAME_FORMAT                                             as NAME_FORMAT
  , FIXED_TITLE_FORMAT_NAME_PREFIX                          as FIXED_TITLE_FORMAT_NAME_PREFIX
  , FIXED_TITLE_FORMAT_NAME_SUFFIX                          as FIXED_TITLE_FORMAT_NAME_SUFFIX
  , FIXED_NAME_FORMAT_FIRST                                 as FIXED_NAME_FORMAT_FIRST
  , FIXED_NAME_FORMAT_MIDDLE                                as FIXED_NAME_FORMAT_MIDDLE
  , FIXED_NAME_FORMAT_LAST                                  as FIXED_NAME_FORMAT_LAST
  , FIXED_FORMAT_RELATIONSHIP_CODE                          as FIXED_FORMAT_RELATIONSHIP_CODE
  , IRS_CODE                                                as IRS_CODE
  , IRS_NO                                                  as IRS_NO
  , case
        when nvl(BIRTH_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(BIRTH_DATE, 'YYYYMMDD') end::date      as BIRTH_DATE
  , TELEPHONE_TYPE_1                                        as TELEPHONE_TYPE_1
  , TELEPHONE_FORMAT_1                                      as TELEPHONE_FORMAT_1
  , TELEPHONE_NUMBER_1                                      as TELEPHONE_NUMBER_1
  , TELEPHONE_EXTENSION_1                                   as TELEPHONE_EXTENSION_1
  , TELEPHONE_PIN_1                                         as TELEPHONE_PIN_1
  , CONTACT_NAME_1                                          as CONTACT_NAME_1
  , PRIORITY_NUMBER_1                                       as PRIORITY_NUMBER_1
  , UPDATE_USER_2                                           as UPDATE_USER_2
  , UPDATE_TIME_STAMP_2                                     as UPDATE_TIME_STAMP_2
  , TELEPHONE_TYPE_2                                        as TELEPHONE_TYPE_2
  , TELEPHONE_FORMAT_2                                      as TELEPHONE_FORMAT_2
  , TELEPHONE_NUMBER_2                                      as TELEPHONE_NUMBER_2
  , TELEPHONE_EXTENSION_2                                   as TELEPHONE_EXTENSION_2
  , TELEPHONE_PIN_2                                         as TELEPHONE_PIN_2
  , CONTACT_NAME_2                                          as CONTACT_NAME_2
  , PRIORITY_NUMBER_2                                       as PRIORITY_NUMBER_2
  , UPDATE_USER_3                                           as UPDATE_USER_3
  , UPDATE_TIME_STAMP_3                                     as UPDATE_TIME_STAMP_3
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}