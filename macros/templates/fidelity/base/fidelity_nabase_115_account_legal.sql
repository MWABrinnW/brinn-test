{%- macro fidelity_nabase_115_account_legal(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                                               as RECORD_TYPE
  , RECORD_NUMBER                                                             as RECORD_NUMBER
  , FIRM                                                                      as FIRM
  , BRANCH                                                                    as BRANCH
  , ACCOUNT_NUMBER                                                            as ACCOUNT_NUMBER
  , AUTO_ADDRESS_UPDATE_INDICATOR                                             as AUTO_ADDRESS_UPDATE_INDICATOR
  , ADDRESS_TYPE                                                              as ADDRESS_TYPE
  , FIXED_FORMAT_ADDRESS_LINE_1                                               as FIXED_FORMAT_ADDRESS_LINE_1
  , FIXED_FORMAT_ADDRESS_LINE_2                                               as FIXED_FORMAT_ADDRESS_LINE_2
  , FIXED_FORMAT_ADDRESS_LINE_3                                               as FIXED_FORMAT_ADDRESS_LINE_3
  , FIXED_FORMAT_CITY_NAME                                                    as FIXED_FORMAT_CITY_NAME
  , FIXED_FORMAT_STATE                                                        as FIXED_FORMAT_STATE
  , FIXED_FORMAT_POSTAL_CODE                                                  as FIXED_FORMAT_POSTAL_CODE
  , FIXED_FORMAT_EXTENDED_ZIP                                                 as FIXED_FORMAT_EXTENDED_ZIP
  , FIXED_FORMAT_PROVINCE                                                     as FIXED_FORMAT_PROVINCE
  , COUNTRY_NAME                                                              as COUNTRY_NAME
  , STATE_COUNTRY_CODE                                                        as STATE_COUNTRY_CODE
  , UPDATE_USER                                                               as UPDATE_USER
  , case
        when nvl(LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_UPDATE_DATE, 'YYYYMMDD') end::date                  as LAST_UPDATE_DATE
  , SEASONAL_ADDRESS_TYPE_CODE                                                as SEASONAL_ADDRESS_TYPE_CODE
  , SEASONAL_ADDRESS_STATUS_CODE                                              as SEASONAL_ADDRESS_STATUS_CODE
  , case
        when nvl(SEASONAL_ADDRESS_START_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(SEASONAL_ADDRESS_START_DATE, 'YYYYMMDD') end::date       as SEASONAL_ADDRESS_START_DATE
  , case
        when nvl(SEASONAL_ADDRESS_END_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(SEASONAL_ADDRESS_END_DATE, 'YYYYMMDD') end::date         as SEASONAL_ADDRESS_END_DATE
  , SEASONAL_ADDRESS_AUTO_ADDRESS_UPDATE_INDICATOR                            as SEASONAL_ADDRESS_AUTO_ADDRESS_UPDATE_INDICATOR
  , SEASONAL_ADDRESS_NCOA_ADDRESS_UPDATE_INDICATOR                            as SEASONAL_ADDRESS_NCOA_ADDRESS_UPDATE_INDICATOR
  , SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_1                              as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_1
  , SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_2                              as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_2
  , SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_3                              as SEASONAL_ADDRESS_FIXED_FORMAT_ADDRESS_LINE_3
  , SEASONAL_ADDRESS_FOREIGN_ADDRESS_CODE                                     as SEASONAL_ADDRESS_FOREIGN_ADDRESS_CODE
  , SEASONAL_ADDRESS_FIXED_FORMAT_CITY_NAME                                   as SEASONAL_ADDRESS_FIXED_FORMAT_CITY_NAME
  , SEASONAL_ADDRESS_FIXED_FORMAT_STATE                                       as SEASONAL_ADDRESS_FIXED_FORMAT_STATE
  , SEASONAL_ADDRESSFIXED_FORMAT_POSTAL_CODE                                  as SEASONAL_ADDRESSFIXED_FORMAT_POSTAL_CODE
  , SEASONAL_ADDRESS_FIXED_FORMAT_PROVINCE                                    as SEASONAL_ADDRESS_FIXED_FORMAT_PROVINCE
  , SEASONAL_ADDRESS_STATE_COUNTRY_CODE                                       as SEASONAL_ADDRESS_STATE_COUNTRY_CODE
  , SEASONAL_ADDRESS_UPDATE_USER                                              as SEASONAL_ADDRESS_UPDATE_USER
  , case
        when nvl(SEASONAL_ADDRESS_LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(SEASONAL_ADDRESS_LAST_UPDATE_DATE, 'YYYYMMDD') end::date as SEASONAL_ADDRESS_LAST_UPDATE_DATE
  , is_head
  , is_current
  , effective_date
  , _created_at
  , _source_file
from {{ src }}
{%- endmacro -%}