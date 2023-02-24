{%- macro fidelity_raw_secmast_29(src) -%}
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as LIMITED_PARTNERSHIP_INDICATOR
  , nullif(trim(substring(content, 5, 1)), '')                                             as MASTER_LIMITED_PARTNERSHIP_INDICATOR
  , nullif(trim(substring(content, 6, 1)), '')                                             as UNIT_INVESTMENT_TRUST_INDICATOR
  , nullif(trim(substring(content, 7, 8)), '')                                             as UIT_TERMINATION_DATE
  , nullif(trim(substring(content, 15, 1)), '')                                            as REAL_ESTATE_INVESTMENT_TRUST_INDICATOR
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date, record_datetime::date as record_date, record_datetime::timestamp as record_datetime, source_file as source_file
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 3) = 'D29'
{%- endmacro -%}