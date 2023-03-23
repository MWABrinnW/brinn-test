{%- macro isca_h(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, to_number(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 10)::number as exchange_rate_between_denom_currency_and_usd
, trim(nullif(substring(content, 39, 9), '000000000'))::varchar(9) as underlying_cusip_1
-- , trim(nullif(substring(content, 48, 4), '0000'))::varchar(4) as not_used_2
, nullif(nullif(trim(substring(content, 52, 5)), '00000'), '')::int as deliverable_unit_quantity
, trim(nullif(substring(content, 57, 9), '000000000'))::varchar(9) as underlying_cusip_2
-- , trim(nullif(substring(content, 66, 4), '0000'))::varchar(4) as not_used_3
, nullif(nullif(trim(substring(content, 70, 5)), '00000'), '')::int as deliverable_unit_quantity_2
, trim(nullif(substring(content, 75, 9), '000000000'))::varchar(9) as underlying_cusip_3
-- , trim(nullif(substring(content, 84, 4), '0000'))::varchar(4) as not_used_4
, nullif(nullif(trim(substring(content, 88, 5)), '00000'), '')::int as deliverable_unit_quantity_3
, trim(nullif(substring(content, 93, 9), '000000000'))::varchar(9) as underlying_cusip_4
-- , trim(nullif(substring(content, 102, 4), '0000'))::varchar(4) as not_used_5
, nullif(nullif(trim(substring(content, 106, 5)), '00000'), '')::int as deliverable_unit_quantity_4
, trim(nullif(substring(content, 111, 3), '000'))::varchar(3) as annual_dividend_currency_code
, to_number(nullif(nullif(trim(substring(content, 114, 18)), '000000000000000000'), '')) / power(10, 02)::number as outstanding_shares
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'H'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
