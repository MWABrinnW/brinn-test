{%- macro fidelity_cgf_acct(src) -%}

SELECT
    effective_date                                                as effective_date
  , 'fidelity-cgf'                                                as custodian
  , {{ "'" ~ src ~ "'" }}                                         as firm_source
  , nullif(trim(substring(content, 1, 10)), '')::varchar(10)      as g_number
  , nullif(trim(substring(content, 11, 10)), '')::varchar(10)     as cgf_account_number
  , nullif(trim(substring(content, 21, 30)), '')::varchar(30)     as last_name
  , nullif(trim(substring(content, 51, 30)), '')::varchar(30)     as first_name
  , nullif(trim(substring(content, 81, 30)), '')::varchar(30)     as middle_name
  , nullif(trim(substring(content, 111, 9)), '')::varchar(9)      as social_security_number
  , nullif(trim(substring(content, 120, 32)), '')::varchar(32)    as address_line_1
  , nullif(trim(substring(content, 152, 32)), '')::varchar(32)    as address_line_2
  , nullif(trim(substring(content, 184, 32)), '')::varchar(32)    as address_line_3
  , nullif(trim(substring(content, 216, 40)), '')::varchar(40)    as city
  , nullif(trim(substring(content, 256, 2)), '')::varchar(2)      as state
  , nullif(trim(substring(content, 258, 10)), '')::varchar(10)    as zip
  , try_to_date(nullif(trim(substring(content, 268, 10)), ''), 'YYYY-MM-DD')::date as date_of_birth
  , {{ col_is_head(reference=source('fidelity_' ~ src, 'cgf_acct')) }}
  , {{ col_is_current(date_col='effective_date') }}
  , record_datetime                                               as _source_loaded_at
  , source_file                                                   as _source_file
from {{ source('fidelity_' ~ src, 'cgf_acct') }}
where 1 = 1
  and left(content, 1) = 'G'

{%- endmacro -%}