{%- macro fidelity_cgf_prc(src) -%}

SELECT
  nullif(trim(substring(content, 1, 9)), '')                     as fund_id
  , nullif(trim(substring(content, 10, 60)), '')                 as fund_name
  , nullif(trim(substring(content, 70, 9)), '')                  as cusip
  , nullif(trim(substring(content, 79, 9)), '')                  as symbol
  , iff(substring(content, 98, 1)='-', -1, 1) * nullif(trim(substring(content, 99, 16)), '')::decimal(16,5) as close_price
  , nullif(trim(substring(content, 115, 2)), '')                 as security_group
  , nullif(trim(substring(content, 117, 2)), '')                 as security_type
  , nullif(trim(substring(content, 119, 40)), '')                as product_type
  , {{ col_is_head(reference=src) }}
  , {{ col_is_current(date_col='effective_date') }}
  , try_to_date(nullif(trim(substring(content, 88, 10)), ''), 'YYYY-MM-DD')::date as effective_date
  , record_datetime                                              as _source_loaded_at
  , source_file                                                  as _source_file
from {{ src }}
where 1 = 1
  and rlike(left(content, 1), '[0-9]')

{%- endmacro -%}