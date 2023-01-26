{%- macro fidelity_raw_secmast_23(src) -%}
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 6)), '')                                             as INITIAL_EXPIRATION_DATE
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date
  , record_datetime                                                                         as _created_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 3) = 'D23'
{%- endmacro -%}