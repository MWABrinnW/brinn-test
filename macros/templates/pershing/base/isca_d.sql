{%- macro isca_d(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 21, 20), '00000000000000000000'))::varchar(20) as security_description_line_6
, signed_to_numeric(nullif(nullif(trim(substring(content, 41, 9)), '000000000'), '')) / power(10, 04)::number as put_price
, YYYYDDD_to_date(nullif(substring(content, 50, 7), '0000000'))::date as put_date
, signed_to_numeric(nullif(nullif(trim(substring(content, 57, 9)), '000000000'), '')) / power(10, 04)::number as second_premium_call_price
, YYYYDDD_to_date(nullif(substring(content, 66, 7), '0000000'))::date as second_premium_call_date
, YYYYDDD_to_date(nullif(substring(content, 73, 7), '0000000'))::date as called_date
, trim(nullif(substring(content, 80, 8), '00000000'))::varchar(8) as pool_number
, signed_to_numeric(nullif(nullif(trim(substring(content, 88, 10)), '0000000000'), '')) / power(10, 08)::number as factor
, YYYYDDD_to_date(nullif(substring(content, 98, 7), '0000000'))::date as factor_date
, signed_to_numeric(nullif(nullif(trim(substring(content, 105, 10)), '0000000000'), '')) / power(10, 08)::number as previous_factor
, YYYYDDD_to_date(nullif(substring(content, 115, 7), '0000000'))::date as previous_factor_date
, trim(nullif(substring(content, 122, 1), '0'))::varchar(1) as variable_rate_indicator
, YYYYDDD_to_date(nullif(substring(content, 123, 7), '0000000'))::date as nextlast_coupon_date
, trim(nullif(substring(content, 130, 1), '0'))::varchar(1) as structured_product_indicator
, trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as perpetual_bond_indicator
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'D'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
