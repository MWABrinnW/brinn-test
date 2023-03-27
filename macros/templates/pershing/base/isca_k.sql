{%- macro isca_k(src) -%}

select
trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
, trim(nullif(substring(content, 17, 3), '000'))::varchar(3) as exchange_code_for_sedol_1
, trim(nullif(substring(content, 20, 7), '0000000'))::varchar(7) as sedol_1
, trim(nullif(substring(content, 27, 3), '000'))::varchar(3) as exchange_code_for_sedol_2
, trim(nullif(substring(content, 30, 7), '0000000'))::varchar(7) as sedol_2
, trim(nullif(substring(content, 37, 3), '000'))::varchar(3) as exchange_code_for_sedol_3
, trim(nullif(substring(content, 40, 7), '0000000'))::varchar(7) as sedol_3
, trim(nullif(substring(content, 47, 3), '000'))::varchar(3) as exchange_code_for_sedol_4
, trim(nullif(substring(content, 50, 7), '0000000'))::varchar(7) as sedol_4
, trim(nullif(substring(content, 57, 3), '000'))::varchar(3) as exchange_code_for_sedol_5
, trim(nullif(substring(content, 60, 7), '0000000'))::varchar(7) as sedol_5
, trim(nullif(substring(content, 67, 3), '000'))::varchar(3) as exchange_code_for_sedol_6
, trim(nullif(substring(content, 70, 7), '0000000'))::varchar(7) as sedol_6
, trim(nullif(substring(content, 77, 3), '000'))::varchar(3) as exchange_code_for_sedol_7
, trim(nullif(substring(content, 80, 7), '0000000'))::varchar(7) as sedol_7
, trim(nullif(substring(content, 87, 3), '000'))::varchar(3) as exchange_code_for_sedol_8
, trim(nullif(substring(content, 90, 7), '0000000'))::varchar(7) as sedol_8
, trim(nullif(substring(content, 97, 3), '000'))::varchar(3) as exchange_code_for_sedol_9
, trim(nullif(substring(content, 100, 7), '0000000'))::varchar(7) as sedol_9
, trim(nullif(substring(content, 107, 3), '000'))::varchar(3) as exchange_code_for_sedol_10
, trim(nullif(substring(content, 110, 7), '0000000'))::varchar(7) as sedol_10
, trim(nullif(substring(content, 117, 3), '000'))::varchar(3) as exchange_code_for_sedol_11
, trim(nullif(substring(content, 120, 7), '0000000'))::varchar(7) as sedol_11
-- , trim(nullif(substring(content, 127, 5), '00000'))::varchar(5) as not_used
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'K'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
