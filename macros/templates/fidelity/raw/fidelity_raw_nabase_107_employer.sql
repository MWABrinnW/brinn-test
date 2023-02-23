{%- macro fidelity_raw_nabase_107_employer(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 1)), '')                                           as AFFILIATION_STATUS
  , nullif(trim(substring(content, 19, 1)), '')                                           as NYSE_RULE_407_INDICATOR
  , nullif(trim(substring(content, 20, 32)), '')                                          as FINANCIAL_INSTITUTION_NAME
  , nullif(trim(substring(content, 52, 32)), '')                                          as FINANCIAL_INSTITUTION_ADDRESS_LINE_1
  , nullif(trim(substring(content, 84, 32)), '')                                          as FINANCIAL_INSTITUTION_ADDRESS_LINE_2
  , nullif(trim(substring(content, 116, 32)), '')                                         as FINANCIAL_INSTITUTION_ADDRESS_LINE_3
  , nullif(trim(substring(content, 148, 50)), '')                                         as OCCUPATION
  , nullif(trim(substring(content, 198, 32)), '')                                         as EMPLOYER_NAME
  , nullif(trim(substring(content, 230, 32)), '')                                         as EMPLOYER_ADDRESS_LINE_1
  , nullif(trim(substring(content, 262, 32)), '')                                         as EMPLOYER_ADDRESS_LINE_2
  , nullif(trim(substring(content, 294, 32)), '')                                         as EMPLOYER_ADDRESS_LINE_3
  , nullif(trim(substring(content, 326, 3)), '')                                          as EMPLOYER_ADDRESS_COUNTRY_CODE
  , nullif(trim(substring(content, 329, 1)), '')                                          as CONTROL_RELATIONSHIP_CODE_1
  , nullif(trim(substring(content, 330, 32)), '')                                         as CONTROL_RELATIONSHIP_COMPANY_NAME_1
  , nullif(trim(substring(content, 362, 20)), '')                                         as CONTROL_RELATIONSHIP_CUSIP_1
  , nullif(trim(substring(content, 382, 1)), '')                                          as CONTROL_RELATIONSHIP_CODE_2
  , nullif(trim(substring(content, 383, 32)), '')                                         as CONTROL_RELATIONSHIP_COMPANY_NAME_2
  , nullif(trim(substring(content, 415, 20)), '')                                         as CONTROL_RELATIONSHIP_CUSIP_2
  , nullif(trim(substring(content, 435, 1)), '')                                          as CONTROL_RELATIONSHIP_CODE_3
  , nullif(trim(substring(content, 436, 32)), '')                                         as CONTROL_RELATIONSHIP_COMPANY_NAME_3
  , nullif(trim(substring(content, 468, 20)), '')                                         as CONTROL_RELATIONSHIP_CUSIP_3
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 4) = 'D107'
{%- endmacro -%}