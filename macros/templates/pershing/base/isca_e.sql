{%- macro isca_e(src) -%}

select
 'pershing'                                                                             as custodian
, {{ "'" ~ src.schema.split('_')[1] ~ "'" }}                                            as firm_source
, trim(nullif(substring(content, 1, 1), '0'))::varchar(1) as record_indicator
, nullif(nullif(trim(substring(content, 2, 6)), '000000'), '')::int as record_id_sequence_number
, trim(nullif(substring(content, 8, 9), '000000000'))::varchar(9) as cusip_number
-- , trim(nullif(substring(content, 17, 4), '0000'))::varchar(4) as not_used
, {{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 21, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_first_call_price_for_fixed_income_or_strike
, {{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 39, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_first_par_call_price_for_fixed_income_or_exercise
, {{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 57, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_put_price
, {{target.schema}}.signed_to_numeric(nullif(nullif(trim(substring(content, 75, 18)), '000000000000000000'), '')) / power(10, 09)::number as expanded_second_premium_call_price
, trim(nullif(substring(content, 93, 32), '00000000000000000000000000000000'))::varchar(32) as name_of_the_issuer_of_the_security
, trim(nullif(substring(content, 125, 3), '000'))::varchar(3) as issuing_currency
, trim(nullif(substring(content, 128, 1), '0'))::varchar(1) as globally_locked_security_indicator
, trim(nullif(substring(content, 129, 1), '0'))::varchar(1) as globally_locked_reason_code
, trim(nullif(substring(content, 130, 1), '0'))::varchar(1) as special_purpose_acquisition_company_spac_indicator
-- , trim(nullif(substring(content, 131, 1), '0'))::varchar(1) as not_used_2
, trim(nullif(substring(content, 132, 1), '0'))::varchar(1) as literally_x
,{{ col_is_head(reference=src) }}
,{{ col_is_current(date_col='effective_date') }}
, effective_date::date as effective_date
, _source_file as _source_file
, _created_at::timestamp as _source_loaded_at
from {{ src }}
where true
and substring(content, 1, 1) = 'E'
and substring(content, 1, 3) not in ('EOF', 'BOF')
{%- endmacro -%}
