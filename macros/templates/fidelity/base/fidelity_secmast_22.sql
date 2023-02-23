{%- macro fidelity_secmast_22(src) -%}
select
    RECORD_TYPE               as RECORD_TYPE
  , RECORD_NUMBER             as RECORD_NUMBER
  , SECURITY_TYPE             as SECURITY_TYPE
  , CLOSED_END_FUND_INDICATOR as CLOSED_END_FUND_INDICATOR
  , EXCHANGE_TRADED           as EXCHANGE_TRADED
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at
  , _source_file
from {{ src }}
{%- endmacro -%}