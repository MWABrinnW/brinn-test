{%- macro fidelity_secmast_2c(src) -%}
select
    RECORD_TYPE    as RECORD_TYPE
  , RECORD_NUMBER  as RECORD_NUMBER
  , SECURITY_TYPE  as SECURITY_TYPE
  , CD_ISSUER_CODE as CD_ISSUER_CODE
  , is_head
  , is_current
  , effective_date
  , _created_at
  , _source_file
from {{ src }}
{%- endmacro -%}