{%- macro isca_l_market_status_oas_libor_data(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 21, 2), '00'))::varchar(2) as primary_idc_market_exchange
, trim(nullif(substring(content, 23, 1), '0'))::varchar(1) as primary_market_exchange_trading_status
, trim(nullif(substring(content, 24, 16), '0000000000000000'))::varchar(16) as primary_market_symbol
, try_to_date(nullif(substring(content, 40, 8), '00000000'), 'YYYYMMDD')::date as primary_market_exchange_effective_date
, trim(nullif(substring(content, 48, 3), '000'))::varchar(3) as primary_market_status_code
, trim(nullif(substring(content, 51, 2), '00'))::varchar(2) as secondary_idc_market_exchange
, trim(nullif(substring(content, 53, 1), '0'))::varchar(1) as secondary_market_exchange_trading_status
, trim(nullif(substring(content, 54, 16), '0000000000000000'))::varchar(16) as secondary_market_symbol
, try_to_date(nullif(substring(content, 70, 8), '00000000'), 'YYYYMMDD')::date as secondary_market_exchange_effective_date
, trim(nullif(substring(content, 78, 3), '000'))::varchar(3) as secondary_market_status_code
, trim(nullif(substring(content, 81, 2), '00'))::varchar(2) as tick_size_pilot_group
, try_to_date(nullif(substring(content, 83, 8), '00000000'), 'YYYYMMDD')::date as tick_size_effective_date
, try_to_date(nullif(substring(content, 91, 8), '00000000'), 'YYYYMMDD')::date as tick_size_change_date
, nullif(nullif(trim(substring(content, 99, 8)), '00000000'), '')::int as update_date
, iff(substring(content, 125, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 107, 18)), '000000000000000000'), '')) / power(10, 09)::number as oas_libor_rate
, trim(nullif(substring(content, 125, 1), '0'))::varchar(1) as oas_libor_rate_sign
-- , trim(nullif(substring(content, 126, 6), '000000'))::varchar(6) as not_used_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'L'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
