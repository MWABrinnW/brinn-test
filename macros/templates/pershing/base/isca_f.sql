{%- macro isca_f(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, signed_to_numeric(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_bid_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 39, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_ask_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 57, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_previous_day_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 75, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_latest_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 93, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_end_of_month_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 111, 17)), '00000000000000000'), '')) / power(10, 02)::number as contract_share_quantity
, nullif(nullif(trim(substring(content, 128, 4)), '0000'), '')::int as year_covered_under_cost_basis_rules
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'F'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
