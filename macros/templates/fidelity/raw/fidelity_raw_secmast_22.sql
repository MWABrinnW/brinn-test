{%- macro fidelity_raw_secmast_22(src) -%}
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as CLOSED_END_FUND_INDICATOR
  , nullif(trim(substring(content, 5, 1)), '')                                             as EXCHANGE_TRADED
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 3) = 'D22'
{%- endmacro -%}