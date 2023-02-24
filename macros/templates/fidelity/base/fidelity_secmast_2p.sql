{%- macro fidelity_secmast_2p(src) -%}
select
    RECORD_TYPE   as RECORD_TYPE
  , RECORD_NUMBER as RECORD_NUMBER
  , SECURITY_TYPE as SECURITY_TYPE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}