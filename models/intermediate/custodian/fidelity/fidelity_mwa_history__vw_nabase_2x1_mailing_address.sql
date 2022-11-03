
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                             as RECORD_TYPE
  , RECORD_NUMBER                                           as RECORD_NUMBER
  , FIRM                                                    as FIRM
  , BRANCH                                                  as BRANCH
  , ACCOUNT_NUMBER                                          as ACCOUNT_NUMBER
  , ADDRESS_TYPE                                            as ADDRESS_TYPE
  , LABEL_LINE_1                                            as LABEL_LINE_1
  , LABEL_LINE_2                                            as LABEL_LINE_2
  , AUTO_ADDRESS_UPDATE_INDICATOR                           as AUTO_ADDRESS_UPDATE_INDICATOR
  , NCOA_ADDRESS_UPDATE_INDICATOR                           as NCOA_ADDRESS_UPDATE_INDICATOR
  , FIXED_FORMAT_ADDRESS_LINE_1                             as FIXED_FORMAT_ADDRESS_LINE_1
  , FIXED_FORMAT_ADDRESS_LINE_2                             as FIXED_FORMAT_ADDRESS_LINE_2
  , FIXED_FORMAT_ADDRESS_LINE_3                             as FIXED_FORMAT_ADDRESS_LINE_3
  , FIXED_FORMAT_PO_BOX                                     as FIXED_FORMAT_PO_BOX
  , FIXED_FORMAT_CITY_NAME                                  as FIXED_FORMAT_CITY_NAME
  , FIXED_FORMAT_STATE                                      as FIXED_FORMAT_STATE
  , FIXED_FORMAT_POSTAL_CODE                                as FIXED_FORMAT_POSTAL_CODE
  , FIXED_FORMAT_EXTENDED_ZIP                               as FIXED_FORMAT_EXTENDED_ZIP
  , FIXED_FORMAT_PROVINCE                                   as FIXED_FORMAT_PROVINCE
  , case
        when nvl(LAST_MAINT_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_MAINT_DATE, 'YYYYMMDD') end::date as LAST_MAINT_DATE
  , FOREIGN_ADDRESS_CODE                                    as FOREIGN_ADDRESS_CODE
  , STATE_COUNTRY_CODE                                      as STATE_COUNTRY_CODE
  , COUNTRY_NAME                                            as COUNTRY_NAME
  , INTERNATIONAL_PO_CODE                                   as INTERNATIONAL_PO_CODE
  , UPDATE_USER                                             as UPDATE_USER
  , UPDATE_TIME_STAMP                                       as UPDATE_TIME_STAMP
  , is_current
  , effective_date
  , record_date
  , record_datetime
  , source_file
from {{ ref('fidelity_mwa_history__vw_raw_nabase_2x1_mailing_address') }}