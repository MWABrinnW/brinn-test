{%- macro fidelity_nabase_102_business(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src ~ "'" }}                                 as firm_source
  , RECORD_TYPE                                                           as RECORD_TYPE
  , RECORD_NUMBER                                                         as RECORD_NUMBER
  , FIRM                                                                  as FIRM
  , BRANCH                                                                as BRANCH
  , ACCOUNT_NUMBER                                                        as ACCOUNT_NUMBER
  , EXCEPTION_REGISTRATION_INDICATOR                                      as EXCEPTION_REGISTRATION_INDICATOR
  , case
        when nvl(FIXED_FORMAT_TRUST_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FIXED_FORMAT_TRUST_DATE, 'YYYYMMDD') end::date       as FIXED_FORMAT_TRUST_DATE
  , MINOR_RESIDENCE_STATE                                                 as MINOR_RESIDENCE_STATE
  , AUTO_ADDRESS_UPDATE_INDICATOR                                         as AUTO_ADDRESS_UPDATE_INDICATOR
  , NCOA_ADDRESS_UPDATE_INDICATOR                                         as NCOA_ADDRESS_UPDATE_INDICATOR
  , FOREIGN_ADDRESS_CODE                                                  as FOREIGN_ADDRESS_CODE
  , FIXED_FORMAT_ADDRESS_LINE_1                                           as FIXED_FORMAT_ADDRESS_LINE_1
  , FIXED_FORMAT_ADDRESS_LINE_2                                           as FIXED_FORMAT_ADDRESS_LINE_2
  , FIXED_FORMAT_ADDRESS_LINE_3                                           as FIXED_FORMAT_ADDRESS_LINE_3
  , FIXED_FORMAT_CITY_NAME                                                as FIXED_FORMAT_CITY_NAME
  , FIXED_FORMAT_STATE                                                    as FIXED_FORMAT_STATE
  , FIXED_FORMAT_POSTAL_CODE                                              as FIXED_FORMAT_POSTAL_CODE
  , STATE_COUNTRY_CODE                                                    as STATE_COUNTRY_CODE
  , FIXED_FORMAT_PROVINCE                                                 as FIXED_FORMAT_PROVINCE
  , FFR_NAME_COUNT                                                        as FFR_NAME_COUNT
  , FIXED_FORMAT_NAME_TYPE_1                                              as FIXED_FORMAT_NAME_TYPE_1
  , FIXED_FORMAT_PRIMARY_NAME_CODE_1                                      as FIXED_FORMAT_PRIMARY_NAME_CODE_1
  , FIXED_FORMAT_BUSINESS_TRUST_NAME_1                                    as FIXED_FORMAT_BUSINESS_TRUST_NAME_1
  , FIXED_FORMAT_RELATIONSHIP_CODE_1                                      as FIXED_FORMAT_RELATIONSHIP_CODE_1
  , FIXED_FORMAT_SSN_NUMBER_1                                             as FIXED_FORMAT_SSN_NUMBER_1
  , FIXED_FORMAT_SSN_CODE_1                                               as FIXED_FORMAT_SSN_CODE_1
  , FFR_XREF_1                                                            as FFR_XREF_1
  , case
        when nvl(FFR_CUSTOMER_ESTABLISH_DATE_1, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FFR_CUSTOMER_ESTABLISH_DATE_1, 'YYYYMMDD') end::date as FFR_CUSTOMER_ESTABLISH_DATE_1
  , FIXED_FORMAT_NAME_TYPE_2                                              as FIXED_FORMAT_NAME_TYPE_2
  , FIXED_FORMAT_PRIMARY_NAME_CODE_2                                      as FIXED_FORMAT_PRIMARY_NAME_CODE_2
  , FIXED_FORMAT_BUSINESS_TRUST_NAME_2                                    as FIXED_FORMAT_BUSINESS_TRUST_NAME_2
  , FIXED_FORMAT_RELATIONSHIP_CODE_2                                      as FIXED_FORMAT_RELATIONSHIP_CODE_2
  , FIXED_FORMAT_SSN_NUMBER_2                                             as FIXED_FORMAT_SSN_NUMBER_2
  , FIXED_FORMAT_SSN_CODE_2                                               as FIXED_FORMAT_SSN_CODE_2
  , FFR_XREF_2                                                            as FFR_XREF_2
  , case
        when nvl(FFR_CUSTOMER_ESTABLISH_DATE_2, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FFR_CUSTOMER_ESTABLISH_DATE_2, 'YYYYMMDD') end::date as FFR_CUSTOMER_ESTABLISH_DATE_2
  , FIXED_FORMAT_NAME_TYPE_3                                              as FIXED_FORMAT_NAME_TYPE_3
  , FIXED_FORMAT_PRIMARY_NAME_CODE_3                                      as FIXED_FORMAT_PRIMARY_NAME_CODE_3
  , FIXED_FORMAT_BUSINESS_TRUST_NAME_3                                    as FIXED_FORMAT_BUSINESS_TRUST_NAME_3
  , FIXED_FORMAT_RELATIONSHIP_CODE_3                                      as FIXED_FORMAT_RELATIONSHIP_CODE_3
  , FIXED_FORMAT_SSN_NUMBER_3                                             as FIXED_FORMAT_SSN_NUMBER_3
  , FIXED_FORMAT_SSN_CODE_3                                               as FIXED_FORMAT_SSN_CODE_3
  , FFR_XREF_3                                                            as FFR_XREF_3
  , case
        when nvl(FFR_CUSTOMER_ESTABLISH_DATE_3, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(FFR_CUSTOMER_ESTABLISH_DATE_3, 'YYYYMMDD') end::date as FFR_CUSTOMER_ESTABLISH_DATE_3
  , FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_1                            as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_1
  , FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_2                            as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_2
  , FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_3                            as FIXED_FORMAT_TRUSTED_CONTACT_STATUS_CODE_3
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ ref('fidelity_' ~ src ~ '_history__vw_raw_nabase_102_business') }}
{%- endmacro -%}