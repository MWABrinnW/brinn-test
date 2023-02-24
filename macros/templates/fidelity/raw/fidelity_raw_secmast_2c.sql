{%- macro fidelity_raw_secmast_2c(src) -%}
select
    nullif(trim(substring(content, 1, 1)), '')                                             as RECORD_TYPE
  , nullif(trim(substring(content, 2, 1)), '')                                             as RECORD_NUMBER
  , nullif(trim(substring(content, 3, 1)), '')                                             as SECURITY_TYPE
  , nullif(trim(substring(content, 4, 1)), '')                                             as CD_ISSUER_CODE
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , effective_date, record_datetime::date as record_date, record_datetime::timestamp as record_datetime, source_file as source_file
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 3) = 'D2C'
{%- endmacro -%}