{%- macro isca_j(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, to_number(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 09)::number as latest_price
, try_to_date(nullif(substring(content, 39, 8), '00000000'), 'YYYYMMDD')::date as latest_price_date
, to_number(nullif(nullif(trim(substring(content, 47, 18)), '000000000000000000'), '')) / power(10, 12)::number as factored_market_value_multiplier_price
, to_number(nullif(nullif(trim(substring(content, 65, 18)), '000000000000000000'), '')) / power(10, 09)::number as current_yield
, to_number(nullif(nullif(trim(substring(content, 83, 18)), '000000000000000000'), '')) / power(10, 09)::number as yield
, trim(nullif(substring(content, 101, 1), '0'))::varchar(1) as price_source
, trim(nullif(substring(content, 102, 2), '00'))::varchar(2) as country_of_origin
, trim(nullif(substring(content, 104, 1), '0'))::varchar(1) as restricted_security_code
, trim(nullif(substring(content, 105, 16), '0000000000000000'))::varchar(16) as international_nondollar_symbol
, trim(nullif(substring(content, 121, 6), '000000'))::varchar(6) as international_exchange
, trim(nullif(substring(content, 127, 3), '000'))::varchar(3) as variable_rate_category_code
, trim(nullif(substring(content, 130, 1), '0'))::varchar(1) as interest_rate_completion_indicator
-- , trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'J'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
