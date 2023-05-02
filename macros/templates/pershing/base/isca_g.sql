{%- macro isca_g(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, iff(substring(content, 39, 1) = '-', -1, 1) * to_number(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 09)::number as delta
, trim(nullif(substring(content, 39, 1), '0'))::varchar(1) as delta_sign
, trim(nullif(substring(content, 40, 1), '0'))::varchar(1) as delta_value_presence_indicator
-- , trim(nullif(substring(content, 41, 12), '000000000000'))::varchar(12) as not_used_2
, trim(nullif(substring(content, 53, 12), '000000000000'))::varchar(12) as isin_code
, trim(nullif(substring(content, 65, 15), '000000000000000'))::varchar(15) as issuer_identifier
, trim(nullif(substring(content, 80, 2), '00'))::varchar(2) as pershing_internal_use_only
-- , trim(nullif(substring(content, 82, 3), '000'))::varchar(3) as not_used_3
, trim(nullif(substring(content, 85, 16), '0000000000000000'))::varchar(16) as symbol_of_the_underlying_security
, trim(nullif(substring(content, 101, 8), '00000000'))::varchar(8) as asset_type
, trim(nullif(substring(content, 109, 8), '00000000'))::varchar(8) as asset_subtype
, trim(nullif(substring(content, 117, 8), '00000000'))::varchar(8) as asset_subsubtype
, nullif(nullif(trim(substring(content, 125, 3)), '000'), '')::int as payment_day_delays
, trim(nullif(substring(content, 128, 4), '0000'))::varchar(4) as reserved_for_future_rating
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'G'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
