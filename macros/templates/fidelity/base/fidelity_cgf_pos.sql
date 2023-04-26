{%- macro fidelity_cgf_pos(src) -%}

SELECT
    nullif(trim(substring(content, 1, 10)), '')::varchar(10) as g_number
  , nullif(trim(substring(content, 11, 10)), '')::varchar(10) as cgf_account_number
  , nullif(trim(substring(content, 21, 9)), '')::varchar(9) as cusip_pool_identifier
  , nullif(trim(substring(content, 30, 9)), '')::varchar(9) as symbol_pool_identifier
  , iff(substring(content, 38, 1)='-', -1, 1) * nullif(trim(substring(content, 40, 16)), '')::decimal(16, 5) as price
  , iff(substring(content, 56, 1)='-', -1, 1) * nullif(trim(substring(content, 57, 14)), '0000000000.000')::decimal(14, 3) as units_value
  , iff(substring(content, 76, 1)='-', -1, 1) * nullif(trim(substring(content, 72, 13)), '0000000000.00')::decimal(13, 2) as market_value
  , nullif(trim(substring(content, 95, 2)), '')::varchar(2) as security_type
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , try_to_date(nullif(trim(substring(content, 85, 10)), ''), 'YYYY-MM-DD')::date as effective_date
  , record_datetime                                                                         as _source_loaded_at
  , source_file                                                                             as _source_file
from {{ src }}
where 1 = 1
  and left(content, 1) = 'G'

{%- endmacro -%}