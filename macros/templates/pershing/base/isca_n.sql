{%- macro isca_n(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, trim(nullif(substring(content, 21, 1), '0'))::varchar(1) as reserved_for_future_use
, try_to_date(nullif(substring(content, 22, 8), '00000000'), 'YYYYMMDD')::date as effective_date_of_the_rate
, to_number(nullif(nullif(trim(substring(content, 30, 18)), '000000000000000000'), '')) / power(10, 09)::number as coupon_interest_rate
, trim(nullif(substring(content, 48, 1), '0'))::varchar(1) as reserved_for_future_use_2
, try_to_date(nullif(substring(content, 49, 8), '00000000'), 'YYYYMMDD')::date as effective_date_of_the_rate_2
, to_number(nullif(nullif(trim(substring(content, 57, 18)), '000000000000000000'), '')) / power(10, 09)::number as coupon_interest_rate_2
, trim(nullif(substring(content, 75, 1), '0'))::varchar(1) as reserved_for_future_use_3
, try_to_date(nullif(substring(content, 76, 8), '00000000'), 'YYYYMMDD')::date as effective_date_of_the_rate_3
, to_number(nullif(nullif(trim(substring(content, 84, 18)), '000000000000000000'), '')) / power(10, 09)::number as coupon_interest_rate_3
, trim(nullif(substring(content, 102, 1), '0'))::varchar(1) as reserved_for_future_use_4
, try_to_date(nullif(substring(content, 103, 8), '00000000'), 'YYYYMMDD')::date as effective_date_of_the_rate_4
, to_number(nullif(nullif(trim(substring(content, 111, 18)), '000000000000000000'), '')) / power(10, 09)::number as coupon_interest_rate_4
-- , trim(nullif(substring(content, 129, 3), '000'))::varchar(3) as not_used_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'N'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
