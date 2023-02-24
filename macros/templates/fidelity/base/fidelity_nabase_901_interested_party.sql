{%- macro fidelity_nabase_901_interested_party(src) -%}
select
    ACCOUNT_CUSTODIAL
  , ACCOUNT_CUSTODIAL_FORMATTED
  , RECORD_TYPE                                              as RECORD_TYPE
  , RECORD_NUMBER                                            as RECORD_NUMBER
  , FIRM                                                     as FIRM
  , BRANCH                                                   as BRANCH
  , ACCOUNT_NUMBER                                           as ACCOUNT_NUMBER
  , IPCS_NUMBER_OF_CONFIRMS                                  as IPCS_NUMBER_OF_CONFIRMS
  , IPCS_NO_STATEMENTS                                       as IPCS_NO_STATEMENTS
  , IPCS_ZIP_CODE                                            as IPCS_ZIP_CODE
  , STATE_COUNTRY_CODE                                       as STATE_COUNTRY_CODE
  , LAST_UPDATE_CODE                                         as LAST_UPDATE_CODE
  , case
        when nvl(LAST_UPDATE_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(LAST_UPDATE_DATE, 'YYYYMMDD') end::date as LAST_UPDATE_DATE
  , NUMBER_OF_ADDRESS_LINES                                  as NUMBER_OF_ADDRESS_LINES
  , IPCS_ADDRESS_LINE_1                                      as IPCS_ADDRESS_LINE_1
  , IPCS_ADDRESS_LINE_2                                      as IPCS_ADDRESS_LINE_2
  , IPCS_ADDRESS_LINE_3                                      as IPCS_ADDRESS_LINE_3
  , IPCS_ADDRESS_LINE_4                                      as IPCS_ADDRESS_LINE_4
  , IPCS_ADDRESS_LINE_5                                      as IPCS_ADDRESS_LINE_5
  , IPCS_ADDRESS_LINE_6                                      as IPCS_ADDRESS_LINE_6
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}