
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                                     as RECORD_TYPE
  , RECORD_NUMBER                                                   as RECORD_NUMBER
  , FIRM                                                            as FIRM
  , BRANCH                                                          as BRANCH
  , ACCOUNT_NUMBER                                                  as ACCOUNT_NUMBER
  , ASTK_TCPN_FIRST_NAME                                            as ASTK_TCPN_FIRST_NAME
  , ASTK_TCPN_MIDDLE_NAME                                           as ASTK_TCPN_MIDDLE_NAME
  , ASTK_TCPN_LAST_NAME                                             as ASTK_TCPN_LAST_NAME
  , ASTK_TCPN_CUSTOMER_ID                                           as ASTK_TCPN_CUSTOMER_ID
  , ASTK_TCPN_ADDRESS_LINE_1                                        as ASTK_TCPN_ADDRESS_LINE_1
  , ASTK_TCPN_ADDRESS_LINE_2                                        as ASTK_TCPN_ADDRESS_LINE_2
  , ASTK_TCPN_CITY                                                  as ASTK_TCPN_CITY
  , ASTK_TCPN_PROVINCE                                              as ASTK_TCPN_PROVINCE
  , ASTK_TCPN_STATE                                                 as ASTK_TCPN_STATE
  , ASTK_TCPN_ZIP_5                                                 as ASTK_TCPN_ZIP_5
  , ASTK_TCPN_ZIP_4                                                 as ASTK_TCPN_ZIP_4
  , case
        when nvl(ASTK_TCPN_DATE_OF_BIRTH, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(ASTK_TCPN_DATE_OF_BIRTH, 'YYYYMMDD') end::date as ASTK_TCPN_DATE_OF_BIRTH
  , CITIZEN_STATUS_CODE                                             as CITIZEN_STATUS_CODE
  , CITIZEN_ORGANIZATION_COUNTRY                                    as CITIZEN_ORGANIZATION_COUNTRY
  , ASTK_TCPN_MAIL_ADDRESS_COUNTRY_CODE                             as ASTK_TCPN_MAIL_ADDRESS_COUNTRY_CODE
  , IRS_NO                                                          as IRS_NO
  , IRS_CODE                                                        as IRS_CODE
  , ASTK_TCPN_RELATIONSHIP_CODE                                     as ASTK_TCPN_RELATIONSHIP_CODE
  , ASTK_TCPN_STAKEHOLDER_TYPE                                      as ASTK_TCPN_STAKEHOLDER_TYPE
  , case
        when nvl(UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(UPDATE_DATE, 'YYYYMMDD') end::date             as UPDATE_DATE
  , ASTK_TCPN_NAME_FORMAT_CODE                                      as ASTK_TCPN_NAME_FORMAT_CODE
  , ASTK_INSTITUTION_NAME                                           as ASTK_INSTITUTION_NAME
  , TRUSTED_CONTACT_ID                                              as TRUSTED_CONTACT_ID
  , TRUSTED_CONTACT_PRIMARY_SECONDARY_CODE                          as TRUSTED_CONTACT_PRIMARY_SECONDARY_CODE
  , TRUSTED_CONTACT_RELATIONSHIP_TO_OWNER                           as TRUSTED_CONTACT_RELATIONSHIP_TO_OWNER
  , TRUSTED_CONTACT_PREFIX                                          as TRUSTED_CONTACT_PREFIX
  , TRUSTED_CONTACT_SUFFIX                                          as TRUSTED_CONTACT_SUFFIX
  , TRUSTED_CONTACT_ADDRESS_FORMAT                                  as TRUSTED_CONTACT_ADDRESS_FORMAT
  , TRUSTED_CONTACT_ATTENTION_LINE                                  as TRUSTED_CONTACT_ATTENTION_LINE
  , TRUSTED_CONTACT_EMAIL_ADDRESS                                   as TRUSTED_CONTACT_EMAIL_ADDRESS
  , TRUSTED_CONTACT_DAY_PHONE_FORMAT                                as TRUSTED_CONTACT_DAY_PHONE_FORMAT
  , TRUSTED_CONTACT_DAY_PHONE_NUMBER                                as TRUSTED_CONTACT_DAY_PHONE_NUMBER
  , TRUSTED_CONTACT_DAY_PHONE_EXTENSION                             as TRUSTED_CONTACT_DAY_PHONE_EXTENSION
  , TRUSTED_CONTACT_DAY_MOBILE_INDICATOR                            as TRUSTED_CONTACT_DAY_MOBILE_INDICATOR
  , TRUSTED_CONTACT_NIGHT_PHONE_FORMAT                              as TRUSTED_CONTACT_NIGHT_PHONE_FORMAT
  , TRUSTED_CONTACT_NIGHT_PHONE_NUMBER                              as TRUSTED_CONTACT_NIGHT_PHONE_NUMBER
  , TRUSTED_CONTACT_NIGHT_PHONE_EXTENSION                           as TRUSTED_CONTACT_NIGHT_PHONE_EXTENSION
  , TRUSTED_CONTACT_NIGHT_MOBILE_INDICATOR                          as TRUSTED_CONTACT_NIGHT_MOBILE_INDICATOR
  , ASTK_PRIMARY_ID_NUMBER                                          as ASTK_PRIMARY_ID_NUMBER
  , ASTK_PRIMARY_ID_TYPE                                            as ASTK_PRIMARY_ID_TYPE
  , ASTK_PRIMARY_ID_STATE                                           as ASTK_PRIMARY_ID_STATE
  , ASTK_PRIMARY_ID_ISSUE_DATE                                      as ASTK_PRIMARY_ID_ISSUE_DATE
  , ASTK_PRIMARY_ID_EXPIRATION_DATE                                 as ASTK_PRIMARY_ID_EXPIRATION_DATE
  , case
        when nvl(ASTK_PERCENT_OWNERSHIP, '') = '' then null::number(18, 2)
        else ASTK_PERCENT_OWNERSHIP::int * .01 end::number(18, 2)   as ASTK_PERCENT_OWNERSHIP
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_nabase_900_stakeholder_and_contact') }}