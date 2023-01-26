{%- macro fidelity_raw_nabase_900_stakeholder_and_contact(src) -%}
select
    trim(substring(content, 9, 3)) || trim(substring(content, 12, 6))                     as ACCOUNT_CUSTODIAL
  , trim(substring(content, 9, 3)) || '-' || trim(substring(content, 12, 6))              as ACCOUNT_CUSTODIAL_FORMATTED
  , nullif(trim(substring(content, 1, 1)), '')                                            as RECORD_TYPE
  , nullif(trim(substring(content, 2, 3)), '')                                            as RECORD_NUMBER
  , nullif(trim(substring(content, 5, 4)), '')                                            as FIRM
  , nullif(trim(substring(content, 9, 3)), '')                                            as BRANCH
  , nullif(trim(substring(content, 12, 6)), '')                                           as ACCOUNT_NUMBER
  , nullif(trim(substring(content, 18, 25)), '')                                          as ASTK_TCPN_FIRST_NAME
  , nullif(trim(substring(content, 43, 10)), '')                                          as ASTK_TCPN_MIDDLE_NAME
  , nullif(trim(substring(content, 53, 30)), '')                                          as ASTK_TCPN_LAST_NAME
  , nullif(trim(substring(content, 83, 9)), '')                                           as ASTK_TCPN_CUSTOMER_ID
  , nullif(trim(substring(content, 92, 50)), '')                                          as ASTK_TCPN_ADDRESS_LINE_1
  , nullif(trim(substring(content, 142, 50)), '')                                         as ASTK_TCPN_ADDRESS_LINE_2
  , nullif(trim(substring(content, 192, 30)), '')                                         as ASTK_TCPN_CITY
  , nullif(trim(substring(content, 222, 30)), '')                                         as ASTK_TCPN_PROVINCE
  , nullif(trim(substring(content, 252, 2)), '')                                          as ASTK_TCPN_STATE
  , nullif(trim(substring(content, 254, 5)), '')                                          as ASTK_TCPN_ZIP_5
  , nullif(trim(substring(content, 259, 4)), '')                                          as ASTK_TCPN_ZIP_4
  , nullif(trim(substring(content, 263, 8)), '')                                          as ASTK_TCPN_DATE_OF_BIRTH
  , nullif(trim(substring(content, 271, 2)), '')                                          as CITIZEN_STATUS_CODE
  , nullif(trim(substring(content, 273, 3)), '')                                          as CITIZEN_ORGANIZATION_COUNTRY
  , nullif(trim(substring(content, 276, 3)), '')                                          as ASTK_TCPN_MAIL_ADDRESS_COUNTRY_CODE
  , nullif(trim(substring(content, 279, 11)), '')                                         as IRS_NO
  , nullif(trim(substring(content, 290, 1)), '')                                          as IRS_CODE
  , nullif(trim(substring(content, 291, 4)), '')                                          as ASTK_TCPN_RELATIONSHIP_CODE
  , nullif(trim(substring(content, 295, 4)), '')                                          as ASTK_TCPN_STAKEHOLDER_TYPE
  , nullif(trim(substring(content, 299, 8)), '')                                          as UPDATE_DATE
  , nullif(trim(substring(content, 307, 1)), '')                                          as ASTK_TCPN_NAME_FORMAT_CODE
  , nullif(trim(substring(content, 308, 50)), '')                                         as ASTK_INSTITUTION_NAME
  , nullif(trim(substring(content, 361, 9)), '')                                          as TRUSTED_CONTACT_ID
  , nullif(trim(substring(content, 370, 1)), '')                                          as TRUSTED_CONTACT_PRIMARY_SECONDARY_CODE
  , nullif(trim(substring(content, 371, 4)), '')                                          as TRUSTED_CONTACT_RELATIONSHIP_TO_OWNER
  , nullif(trim(substring(content, 375, 10)), '')                                         as TRUSTED_CONTACT_PREFIX
  , nullif(trim(substring(content, 385, 10)), '')                                         as TRUSTED_CONTACT_SUFFIX
  , nullif(trim(substring(content, 395, 1)), '')                                          as TRUSTED_CONTACT_ADDRESS_FORMAT
  , nullif(trim(substring(content, 396, 50)), '')                                         as TRUSTED_CONTACT_ATTENTION_LINE
  , nullif(trim(substring(content, 446, 80)), '')                                         as TRUSTED_CONTACT_EMAIL_ADDRESS
  , nullif(trim(substring(content, 526, 1)), '')                                          as TRUSTED_CONTACT_DAY_PHONE_FORMAT
  , nullif(trim(substring(content, 527, 15)), '')                                         as TRUSTED_CONTACT_DAY_PHONE_NUMBER
  , nullif(trim(substring(content, 542, 4)), '')                                          as TRUSTED_CONTACT_DAY_PHONE_EXTENSION
  , nullif(trim(substring(content, 546, 1)), '')                                          as TRUSTED_CONTACT_DAY_MOBILE_INDICATOR
  , nullif(trim(substring(content, 547, 1)), '')                                          as TRUSTED_CONTACT_NIGHT_PHONE_FORMAT
  , nullif(trim(substring(content, 548, 15)), '')                                         as TRUSTED_CONTACT_NIGHT_PHONE_NUMBER
  , nullif(trim(substring(content, 563, 4)), '')                                          as TRUSTED_CONTACT_NIGHT_PHONE_EXTENSION
  , nullif(trim(substring(content, 567, 1)), '')                                          as TRUSTED_CONTACT_NIGHT_MOBILE_INDICATOR
  , nullif(trim(substring(content, 568, 30)), '')                                         as ASTK_PRIMARY_ID_NUMBER
  , nullif(trim(substring(content, 598, 1)), '')                                          as ASTK_PRIMARY_ID_TYPE
  , nullif(trim(substring(content, 599, 2)), '')                                          as ASTK_PRIMARY_ID_STATE
  , nullif(trim(substring(content, 601, 8)), '')                                          as ASTK_PRIMARY_ID_ISSUE_DATE
  , nullif(trim(substring(content, 609, 8)), '')                                          as ASTK_PRIMARY_ID_EXPIRATION_DATE
  , nullif(trim(substring(content, 617, 5)), '')                                          as ASTK_PERCENT_OWNERSHIP
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _created_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 4) = 'D900'
{%- endmacro -%}