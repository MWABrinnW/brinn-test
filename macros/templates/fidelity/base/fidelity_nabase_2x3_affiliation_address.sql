{%- macro fidelity_nabase_2x3_affiliation_address(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src.identifier.split('_')[1].lower() ~ "'" }}                                 as firm_source
  , RECORD_TYPE                                             as RECORD_TYPE
  , RECORD_SEGMENT                                          as RECORD_SEGMENT
  , FIRM                                                    as FIRM
  , BRANCH                                                  as BRANCH
  , ACCOUNT_NUMBER                                          as ACCOUNT_NUMBER
  , ADDRESS_TYPE                                            as ADDRESS_TYPE
  , LABEL_LINE_1                                            as LABEL_LINE_1
  , LABEL_LINE_2                                            as LABEL_LINE_2
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
  , ADDRESS_FORMAT                                          as ADDRESS_FORMAT
  , STATE_COUNTRY_CODE                                      as STATE_COUNTRY_CODE
  , COUNTRY_NAME                                            as COUNTRY_NAME
  , INTERNATIONAL_PO_CODE                                   as INTERNATIONAL_PO_CODE
  , UPDATE_USER                                             as UPDATE_USER
  , UPDATE_TIME_STAMP                                       as UPDATE_TIME_STAMP
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}