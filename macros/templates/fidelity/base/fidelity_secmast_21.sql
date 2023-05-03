{%- macro fidelity_secmast_21(src) -%}
select
    RECORD_TYPE                    as RECORD_TYPE
  , RECORD_NUMBER                  as RECORD_NUMBER
  , 'fidelity'                                                                             as custodian
  , {{ "'" ~ src ~ "'" }}                                 as firm_source
  , SECURITY_TYPE                  as SECURITY_TYPE
  , CLOSED_END_FUND_INDICATOR      as CLOSED_END_FUND_INDICATOR
  , EXCHANGE_TRADED_FUND_INDICATOR as EXCHANGE_TRADED_FUND_INDICATOR
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ ref('fidelity_' ~ src ~ '_history__vw_raw_secmast_21') }}
{%- endmacro -%}