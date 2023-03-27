{%- macro isca_i(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 21, 6), '000000'))::varchar(6) as option_root_id
, try_to_date(nullif(substring(content, 27, 6), '000000'), 'YYMMDD')::date as expiration_date
, trim(nullif(substring(content, 33, 1), '0'))::varchar(1) as callput_indicator
, to_number(nullif(nullif(trim(substring(content, 34, 8)), '00000000'), '')) / power(10, 03)::number as strike_price
, trim(nullif(substring(content, 42, 1), '0'))::varchar(1) as fund_type
, trim(nullif(substring(content, 43, 1), '0'))::varchar(1) as broadnarrow_indicator
, iff(substring(content, 62, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 44, 18)), '000000000000000000'), '')) / power(10, 09)::number as leverage_factor
, trim(nullif(substring(content, 62, 1), '0'))::varchar(1) as leverage_factor_sign
, nullif(nullif(trim(substring(content, 63, 8)), '00000000'), '')::int as outstanding_shares_update_date
, trim(nullif(substring(content, 71, 16), '0000000000000000'))::varchar(16) as expanded_symbol
, trim(nullif(substring(content, 87, 2), '00'))::varchar(2) as state_of_issuance
, trim(nullif(substring(content, 89, 1), '0'))::varchar(1) as option_exercise_pricing_model_code
, try_to_date(nullif(substring(content, 90, 8), '00000000'), 'YYYYMMDD')::date as first_accrual_date
, trim(nullif(substring(content, 98, 6), '000000'))::varchar(6) as tranche_code
-- , trim(nullif(substring(content, 104, 2), '00'))::varchar(2) as not_used_2
, trim(nullif(substring(content, 106, 1), '0'))::varchar(1) as worthless_security_indicator
, try_to_date(nullif(substring(content, 107, 8), '00000000'), 'YYYYMMDD')::date as uit_termination_date
, trim(nullif(substring(content, 115, 8), '00000000'))::varchar(8) as fdic_certification_number
, trim(nullif(substring(content, 123, 3), '000'))::varchar(3) as revenue_stream
, trim(nullif(substring(content, 126, 1), '0'))::varchar(1) as restricted_marijuana_indicator
-- , trim(nullif(substring(content, 127, 5), '00000'))::varchar(5) as not_used_3
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'I'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
