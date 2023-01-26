{%- macro fidelity_secmast_2b(src) -%}
select
    RECORD_TYPE   as RECORD_TYPE
  , RECORD_NUMBER as RECORD_NUMBER
  , SECURITY_TYPE as SECURITY_TYPE
  , is_head
  , is_current
  , effective_date
  , _created_at
  , _source_file
from {{ src }}
{%- endmacro -%}