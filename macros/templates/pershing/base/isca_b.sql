{%- macro isca_b(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 3), '000'))::varchar(3) as not_used
, trim(nullif(substring(content, 20, 1), '0'))::varchar(1) as etf_indicator
, signed_to_numeric(nullif(nullif(trim(substring(content, 21, 9)), '000000000'), '')) / power(10, 04)::number as bid_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 30, 9)), '000000000'), '')) / power(10, 04)::number as ask_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 39, 9)), '000000000'), '')) / power(10, 04)::number as previous_day_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 48, 9)), '000000000'), '')) / power(10, 04)::number as latest_price
, signed_to_numeric(nullif(nullif(trim(substring(content, 57, 9)), '000000000'), '')) / power(10, 04)::number as end_of_month_price
, nullif(nullif(trim(substring(content, 66, 13)), '0000000000000'), '')::int as round_lot_quantity
, trim(nullif(substring(content, 79, 1), '0'))::varchar(1) as dividend_reinvestment_eligibility_indicator
, YYYYDDD_to_date(nullif(substring(content, 80, 7), '0000000'))::date as previous_price_date
, YYYYDDD_to_date(nullif(substring(content, 87, 7), '0000000'))::date as latest_price_date
, YYYYDDD_to_date(nullif(substring(content, 94, 7), '0000000'))::date as end_of_month_price_date
, YYYYDDD_to_date(nullif(substring(content, 101, 7), '0000000'))::date as record_date
, trim(nullif(substring(content, 108, 1), '0'))::varchar(1) as fundvest_indicator
, trim(nullif(substring(content, 109, 3), '000'))::varchar(3) as country_code
, trim(nullif(substring(content, 112, 4), '0000'))::varchar(4) as standard
, trim(nullif(substring(content, 116, 5), '00000'))::varchar(5) as moodys_rating
, trim(nullif(substring(content, 121, 1), '0'))::varchar(1) as bond_sub_class
, trim(nullif(substring(content, 122, 4), '0000'))::varchar(4) as restriction_indicator
, trim(nullif(substring(content, 126, 1), '0'))::varchar(1) as trace_indicator
, trim(nullif(substring(content, 127, 1), '0'))::varchar(1) as new_interest_calculation_code
, trim(nullif(substring(content, 128, 4), '0000'))::varchar(4) as standard_industrial_classification_sic_code
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'B'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
