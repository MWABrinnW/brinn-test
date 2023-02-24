{%- macro fidelity_secmast_23(src) -%}
select
    RECORD_TYPE                                                   as RECORD_TYPE
  , RECORD_NUMBER                                                 as RECORD_NUMBER
  , SECURITY_TYPE                                                 as SECURITY_TYPE
  , case
        when nvl(INITIAL_EXPIRATION_DATE, '') in ('', '0000', '000000', '00000000') then null::date
        else to_date(INITIAL_EXPIRATION_DATE, 'YYMMDD') end::date as INITIAL_EXPIRATION_DATE
  , is_head
  , is_current
  , effective_date
  , _source_loaded_at, _source_loaded_at::date as record_date, _source_loaded_at::timestamp as record_datetime
  , _source_file
from {{ src }}
{%- endmacro -%}