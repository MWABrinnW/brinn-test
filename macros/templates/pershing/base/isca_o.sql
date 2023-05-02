{%- macro isca_o(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, iff(substring(content, 39, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 09)::number as oas_treasury_rate
, trim(nullif(substring(content, 39, 1), '0'))::varchar(1) as oas_treasury_rate_sign
, nullif(nullif(trim(substring(content, 40, 8)), '00000000'), '')::int as oas_treasury_effectiveupdate_date
, to_number(nullif(nullif(trim(substring(content, 48, 15)), '000000000000000'), '')) / power(10, 03)::number as minimum_piece
, to_number(nullif(nullif(trim(substring(content, 63, 15)), '000000000000000'), '')) / power(10, 03)::number as minimum_increment
-- , trim(nullif(substring(content, 78, 54), '000000000000000000000000000000000000000000000000000000'))::varchar(54) as not_used_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'O'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
